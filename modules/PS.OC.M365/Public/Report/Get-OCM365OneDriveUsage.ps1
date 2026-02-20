function Get-OCM365OneDriveUsage {
    <#
    .SYNOPSIS
        Retrieves OneDrive usage report for users.

    .DESCRIPTION
        Gets detailed OneDrive storage usage information for all users in the tenant.
        Returns data such as storage used, file count, and active file count.

    .PARAMETER Period
        The report period. Valid values are: D7, D30, D90, D180.
        Default is D180 (last 180 days).

    .EXAMPLE
        Get-OCM365OneDriveUsage
        Retrieves OneDrive usage for the last 180 days.

    .EXAMPLE
        Get-OCM365OneDriveUsage -Period D30
        Retrieves OneDrive usage for the last 30 days.

    .NOTES
        Requires Microsoft Graph PowerShell module and an active Graph connection.
        Required Graph API permissions: Reports.Read.All
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet('D7', 'D30', 'D90', 'D180')]
        [string]$Period = 'D180'
    )

    begin {
        Write-Debug "[Get-OCM365OneDriveUsage] Starting function with Period: $Period"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365OneDriveUsage] Successfully validated Graph connection"

        # Check required permissions
        $requiredScopes = @('Reports.Read.All')
        $currentScopes = $mgContext.Scopes
        Write-Debug "[Get-OCM365OneDriveUsage] Current scopes: $($currentScopes -join ', ')"

        $missingScopes = $requiredScopes | Where-Object { $_ -notin $currentScopes }
        if ($missingScopes) {
            $message = "Missing required permissions: $($missingScopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Information "Retrieving OneDrive usage report for period: $Period" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving OneDrive usage report for period: $Period" -Verbose:$VerbosePreference
        
        try {
            Write-Debug "[Get-OCM365OneDriveUsage] Calling Invoke-MgGraphRequest for OneDrive usage"
            
            $reportType = 'getOneDriveUsageAccountDetail'
            $response = Invoke-MgGraphRequest `
                -Method GET `
                -Uri "https://graph.microsoft.com/v1.0/reports/$reportType(period='$Period')" `
                -OutputType HttpResponseMessage `
                -Verbose:$VerbosePreference `
                -Debug:$DebugPreference
            
            Write-Debug "[Get-OCM365OneDriveUsage] Converting CSV response"
            $csvContent = $response.Content.ReadAsStringAsync().Result
            $data = $csvContent | ConvertFrom-Csv
            
            Write-Information "Retrieved $($data.Count) OneDrive usage records" -InformationAction $InformationPreference
            Write-Verbose "Retrieved $($data.Count) records" -Verbose:$VerbosePreference
            return $data
        }
        catch {
            Write-Error "Failed to retrieve OneDrive usage report: $_" -ErrorAction Stop
            throw
        }
    }
}
