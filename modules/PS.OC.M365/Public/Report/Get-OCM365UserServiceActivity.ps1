function Get-OCM365UserServiceActivity {
    <#
    .SYNOPSIS
        Retrieves Office 365 active user detail report.

    .DESCRIPTION
        Gets detailed active user report showing activity across all Office 365 services.
        Returns data about user activity in Exchange, SharePoint, OneDrive, Teams, Yammer, and Skype.

    .PARAMETER Period
        The report period. Valid values are: D7, D30, D90, D180.
        Default is D180 (last 180 days).

    .EXAMPLE
        Get-OCM365UserServiceActivity
        Retrieves user service activity for the last 180 days.

    .EXAMPLE
        Get-OCM365UserServiceActivity -Period D30
        Retrieves user service activity for the last 30 days.

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
        Write-Debug "[Get-OCM365UserServiceActivity] Starting function with Period: $Period"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365UserServiceActivity] Successfully validated Graph connection"

        # Check required permissions
        $requiredScopes = @('Reports.Read.All')
        $currentScopes = $mgContext.Scopes
        Write-Debug "[Get-OCM365UserServiceActivity] Current scopes: $($currentScopes -join ', ')"

        $missingScopes = $requiredScopes | Where-Object { $_ -notin $currentScopes }
        if ($missingScopes) {
            $message = "Missing required permissions: $($missingScopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Information "Retrieving Office 365 active user detail report for period: $Period" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving Office 365 active user detail report for period: $Period" -Verbose:$VerbosePreference
        
        try {
            Write-Debug "[Get-OCM365UserServiceActivity] Calling Invoke-MgGraphRequest for user service activity"
            
            $reportType = 'getOffice365ActiveUserDetail'
            $response = Invoke-MgGraphRequest `
                -Method GET `
                -Uri "https://graph.microsoft.com/v1.0/reports/$reportType(period='$Period')" `
                -OutputType HttpResponseMessage `
                -Verbose:$VerbosePreference `
                -Debug:$DebugPreference
            
            Write-Debug "[Get-OCM365UserServiceActivity] Converting CSV response"
            $csvContent = $response.Content.ReadAsStringAsync().Result
            $data = $csvContent | ConvertFrom-Csv
            
            Write-Information "Retrieved $($data.Count) user service activity records" -InformationAction $InformationPreference
            Write-Verbose "Retrieved $($data.Count) records" -Verbose:$VerbosePreference
            return $data
        }
        catch {
            Write-Error "Failed to retrieve user service activity report: $_" -ErrorAction Stop
            throw
        }
    }
}
