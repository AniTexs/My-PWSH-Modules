function Get-OCM365OneDriveActivity {
    <#
    .SYNOPSIS
        Retrieves OneDrive activity report for users.

    .DESCRIPTION
        Gets detailed OneDrive activity information for all users in the tenant.
        Returns data such as file sync, share, and view activity.

    .PARAMETER Period
        The report period. Valid values are: D7, D30, D90, D180.
        Default is D180 (last 180 days).

    .EXAMPLE
        Get-OCM365OneDriveActivity
        Retrieves OneDrive activity for the last 180 days.

    .EXAMPLE
        Get-OCM365OneDriveActivity -Period D30
        Retrieves OneDrive activity for the last 30 days.

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
        Write-Debug "[Get-OCM365OneDriveActivity] Starting function with Period: $Period"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365OneDriveActivity] Successfully validated Graph connection"

        # Check required permissions
        $requiredScopes = @('Reports.Read.All')
        $currentScopes = $mgContext.Scopes
        Write-Debug "[Get-OCM365OneDriveActivity] Current scopes: $($currentScopes -join ', ')"

        $missingScopes = $requiredScopes | Where-Object { $_ -notin $currentScopes }
        if ($missingScopes) {
            $message = "Missing required permissions: $($missingScopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Information "Retrieving OneDrive activity report for period: $Period" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving OneDrive activity report for period: $Period" -Verbose:$VerbosePreference
        
        try {
            Write-Debug "[Get-OCM365OneDriveActivity] Calling Invoke-MgGraphRequest for OneDrive activity"
            
            $reportType = 'getOneDriveActivityUserDetail'
            $response = Invoke-MgGraphRequest `
                -Method GET `
                -Uri "https://graph.microsoft.com/v1.0/reports/$reportType(period='$Period')" `
                -OutputType HttpResponseMessage `
                -Verbose:$VerbosePreference `
                -Debug:$DebugPreference
            
            Write-Debug "[Get-OCM365OneDriveActivity] Converting CSV response"
            $csvContent = $response.Content.ReadAsStringAsync().Result
            $data = $csvContent | ConvertFrom-Csv
            
            Write-Information "Retrieved $($data.Count) OneDrive activity records" -InformationAction $InformationPreference
            Write-Verbose "Retrieved $($data.Count) records" -Verbose:$VerbosePreference
            return $data
        }
        catch {
            Write-Error "Failed to retrieve OneDrive activity report: $_" -ErrorAction Stop
            throw
        }
    }
}
