function Get-OCM365SignInLog {
    <#
    .SYNOPSIS
        Retrieves Azure AD sign-in logs for users using batch API requests.

    .DESCRIPTION
        Gets sign-in audit logs from Azure AD for specified users or all member users.
        Uses Microsoft Graph batch API for efficient retrieval of large numbers of user sign-in logs.
        Implements rate limiting handling and retry logic with exponential backoff.

    .PARAMETER StartDate
        The start date for filtering sign-in logs. Defaults to 6 months ago.

    .PARAMETER ExcludeUPNDomains
        Array of UPN domains to exclude from the query.

    .PARAMETER UserFilter
        OData filter for querying users. Defaults to "userType eq 'member'".

    .PARAMETER BatchSize
        Number of users to process in each batch. Default is 20.

    .PARAMETER MaxRetryAttempts
        Maximum number of retry attempts for rate-limited requests. Default is 5.

    .EXAMPLE
        Get-OCM365SignInLog
        Retrieves sign-in logs for all member users for the last 6 months.

    .EXAMPLE
        Get-OCM365SignInLog -StartDate (Get-Date).AddMonths(-3) -ExcludeUPNDomains @("external.com")
        Retrieves sign-in logs for the last 3 months, excluding users from external.com domain.

    .NOTES
        Requires Microsoft Graph PowerShell module and an active Graph connection.
        Required Graph API permissions: AuditLog.Read.All, User.Read.All
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [DateTime]$StartDate = (Get-Date).AddMonths(-6),

        [Parameter()]
        [string[]]$ExcludeUPNDomains = @(),

        [Parameter()]
        [string[]]$UserFilter = @("userType eq 'member'"),

        [Parameter()]
        [int]$BatchSize = 20,

        [Parameter()]
        [int]$MaxRetryAttempts = 5
    )

    begin {
        Write-Debug "[Get-OCM365SignInLog] Starting function with StartDate: $($StartDate.ToString('yyyy-MM-dd')), BatchSize: $BatchSize, MaxRetryAttempts: $MaxRetryAttempts"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365SignInLog] Successfully validated Graph connection"

        # Check required permissions using the permission hierarchy function
        $requiredScopes = @('AuditLog.Read.All', 'User.Read.All')
        if (-not (Test-OCM365GraphPermission -RequiredPermissions $requiredScopes -Scopes $mgContext.Scopes)) {
            $message = "Missing required permissions: $($requiredScopes -join ', '). Current scopes: $($mgContext.Scopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Debug "[Get-OCM365SignInLog] Permission validation successful"

        # Load System.Web for URL encoding
        Write-Debug "[Get-OCM365SignInLog] Loading System.Web assembly"
        Add-Type -AssemblyName System.Web

        $InitialDelay = 100  # Initial delay between batches in milliseconds
        
        Write-Information "Starting sign-in log retrieval from $($StartDate.ToString('yyyy-MM-dd'))" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Starting audit log retrieval using JSON batching..." -Verbose:$VerbosePreference
        Write-Verbose "Date filter: $($StartDate.ToString('yyyy-MM-dd'))" -Verbose:$VerbosePreference
        Write-Debug "[Get-OCM365SignInLog] Excluded domains: $($ExcludeUPNDomains -join ', ')"

        # Get users
        Write-Verbose "Retrieving users from Azure AD..." -Verbose:$VerbosePreference
        Write-Debug "[Get-OCM365SignInLog] User filter: $($UserFilter -join ' and ')"
        
        $MgUsers = Get-MgUser -Filter ($UserFilter -join " and ") `
            -All `
            -ConsistencyLevel eventual `
            -CountVariable UserCount `
            -Verbose:$VerbosePreference `
            -Debug:$DebugPreference |
            Where-Object { 
                $domain = ($_.UserPrincipalName -split '@')[1]
                $ExcludeUPNDomains -notcontains $domain -and 
                $null -ne $_.UserPrincipalName 
            }

        $Total = $MgUsers.Count
        if ($Total -eq 0) { 
            Write-Warning "No users found to process."
            Write-Information "No users matched the filter criteria" -InformationAction $InformationPreference
            return 
        }

        Write-Information "Found $Total users to process" -InformationAction $InformationPreference
        Write-Verbose "Found $Total users to process" -Verbose:$VerbosePreference
        Write-Debug "[Get-OCM365SignInLog] User retrieval complete. Count: $Total"

        # Process users in batches
        $allResults = @()
        $processedCount = 0
        $rateLimitedUsers = @()

        Write-Information "Processing users in batches of $BatchSize" -InformationAction $InformationPreference
        Write-Debug "[Get-OCM365SignInLog] Starting batch processing with batch size: $BatchSize"

        for ($i = 0; $i -lt $Total; $i += $BatchSize) {
            $batchEnd = [Math]::Min($i + $BatchSize, $Total)
            $batch = $MgUsers[$i..($batchEnd - 1)]

            Write-Progress -Activity "Processing users" `
                -Status "Processing batch $([Math]::Floor($i / $BatchSize) + 1) of $([Math]::Ceiling($Total / $BatchSize))" `
                -PercentComplete (($i / $Total) * 100) `
                -ProgressAction $ProgressPreference

            Write-Verbose "Processing batch with $($batch.Count) users" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365SignInLog] Processing batch: Users $i to $($batchEnd - 1)"

            # Process this batch with rate limit tracking
            $rateLimitRef = [ref]$rateLimitedUsers
            $batchResults = Invoke-SignInBatch -Users $batch `
                -Date $StartDate `
                -RateLimitedUsers $rateLimitRef `
                -Verbose:$VerbosePreference `
                -Debug:$DebugPreference `
                -InformationAction $InformationPreference

            if ($batchResults) {
                $allResults += $batchResults
                $processedCount += $batch.Count
                Write-Information "Retrieved $($batchResults.Count) sign-in records from this batch" -InformationAction $InformationPreference
                Write-Debug "[Get-OCM365SignInLog] Batch complete: $($batchResults.Count) records, Total processed: $processedCount"
            }

            # Small delay between batches to be respectful of API
            if ($i + $BatchSize -lt $Total) {
                Write-Verbose "Waiting for rate limit compliance (${InitialDelay}ms)" -Verbose:$VerbosePreference
                Start-Sleep -Milliseconds $InitialDelay
            }
        }

        # Process rate limited users with retry logic
        $retryAttempt = 0
        $currentRateLimitedUsers = $rateLimitedUsers

        Write-Debug "[Get-OCM365SignInLog] Rate-limited users count: $($currentRateLimitedUsers.Count)"

        while ($currentRateLimitedUsers.Count -gt 0 -and $retryAttempt -lt $MaxRetryAttempts) {
            Write-Information "Retrying $($currentRateLimitedUsers.Count) rate-limited users (Attempt $($retryAttempt + 1) of $MaxRetryAttempts)" -InformationAction $InformationPreference
            Write-Verbose "Processing $($currentRateLimitedUsers.Count) rate-limited users (Retry attempt $($retryAttempt + 1)/$MaxRetryAttempts)" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365SignInLog] Retry attempt $($retryAttempt + 1) for $($currentRateLimitedUsers.Count) users"

            $retryResult = Invoke-RateLimitedUserRetry `
                -RateLimitedUsers $currentRateLimitedUsers `
                -Date $StartDate `
                -RetryAttempt $retryAttempt `
                -InitialDelay $InitialDelay `
                -CurrentBatchSize $BatchSize `
                -Verbose:$VerbosePreference `
                -Debug:$DebugPreference `
                -InformationAction $InformationPreference

            if ($retryResult.Results) {
                $allResults += $retryResult.Results
                $processedCount += ($currentRateLimitedUsers.Count - $retryResult.NewRateLimitedUsers.Count)
                Write-Information "Retry retrieved $($retryResult.Results.Count) additional records" -InformationAction $InformationPreference
                Write-Debug "[Get-OCM365SignInLog] Retry batch: $($retryResult.Results.Count) records, Remaining rate-limited users: $($retryResult.NewRateLimitedUsers.Count)"
            }

            # Update for next iteration
            $currentRateLimitedUsers = $retryResult.NewRateLimitedUsers
            $retryAttempt++
        }

        # Report on any remaining rate limited users
        if ($currentRateLimitedUsers.Count -gt 0) {
            Write-Error "Unable to process $($currentRateLimitedUsers.Count) users after $MaxRetryAttempts retry attempts due to persistent rate limiting" -ErrorAction Continue
            Write-Verbose "Rate-limited users:" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365SignInLog] Remaining rate-limited users: $($currentRateLimitedUsers.Count)"
            $currentRateLimitedUsers | ForEach-Object { 
                Write-Verbose "  - $($_.UserPrincipalName)" -Verbose:$VerbosePreference
                Write-Debug "[Get-OCM365SignInLog] Rate-limited user: $($_.UserPrincipalName)"
            }
        }

        Write-Progress -Activity "Processing users" -Completed -ProgressAction $ProgressPreference
        
        Write-Information "Processing complete!" -InformationAction $InformationPreference
        Write-Verbose "Processing complete!" -Verbose:$VerbosePreference
        Write-Verbose "Total users processed: $processedCount" -Verbose:$VerbosePreference
        Write-Verbose "Sign-in records found: $($allResults.Count)" -Verbose:$VerbosePreference
        Write-Debug "[Get-OCM365SignInLog] Final statistics - Processed users: $processedCount, Records retrieved: $($allResults.Count)"

        # Output results
        $allResults
    }
}
