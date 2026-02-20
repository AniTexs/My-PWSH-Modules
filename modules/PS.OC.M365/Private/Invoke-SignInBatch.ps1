function Invoke-SignInBatch {
    <#
    .SYNOPSIS
        Processes a batch of users to retrieve their sign-in logs.

    .DESCRIPTION
        Creates batch requests for multiple users and retrieves their most recent sign-in logs
        from Azure AD using the Microsoft Graph batch API.

    .PARAMETER Users
        Array of user objects to process.

    .PARAMETER Date
        Start date for filtering sign-in logs.

    .PARAMETER RateLimitedUsers
        Reference to an array for tracking users that encounter rate limiting.

    .EXAMPLE
        $users = Get-MgUser -Top 10
        $rateLimited = @()
        Invoke-SignInBatch -Users $users -Date (Get-Date).AddMonths(-1) -RateLimitedUsers ([ref]$rateLimited)

    .NOTES
        This is a private helper function for use within the PS.OC.M365 module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]$Users,

        [Parameter(Mandatory)]
        [DateTime]$Date,

        [Parameter()]
        [ref]$RateLimitedUsers
    )
    
    $batchRequests = @()
    $userMap = @{}
    
    # Create batch requests for each user
    foreach ($user in $Users) {
        $filter = @(
            "createdDateTime ge $($Date.ToString('yyyy-MM-dd'))T00:00:00Z"
            "userPrincipalName eq '$($user.UserPrincipalName.ToLower())'"
        ) -join ' and '
        
        # URL encode the filter
        $encodedFilter = [System.Web.HttpUtility]::UrlEncode($filter)
        
        # Create the request URL - using relative URL for batch
        $url = "/auditLogs/signIns?`$filter=$encodedFilter&`$top=1"
        
        $requestId = [guid]::NewGuid().ToString()
        $batchRequests += New-GraphBatchRequest -Id $requestId -Url $url
        
        # Map request ID to user for later processing
        $userMap[$requestId] = $user
    }
    
    # Execute batch request
    Write-Verbose "Processing batch of $($batchRequests.Count) users..."
    $responses = Invoke-GraphBatchRequest -Requests $batchRequests
    
    if ($null -eq $responses) {
        Write-Warning "Batch request failed for users"
        return
    }
    
    # Process responses
    $results = @()
    foreach ($response in $responses) {
        $user = $userMap[$response.id]
        
        if ($response.status -eq 200) {
            if ($response.body.value -and $response.body.value.Count -gt 0) {
                $signIn = $response.body.value[0]
                $results += $signIn
            }
        }
        elseif ($response.status -eq 429) {
            Write-Warning "Rate limited for user $($user.UserPrincipalName). Status: $($response.status)"
            # Add to retry queue
            if ($null -ne $RateLimitedUsers) {
                $RateLimitedUsers.Value += $user
            }
        }
        else {
            Write-Warning "Failed to get sign-in for $($user.UserPrincipalName). Status: $($response.status)"
            if ($response.body.error) {
                Write-Warning "Error: $($response.body.error.message)"
            }
        }
    }
    
    return $results
}
