function Get-OCM365UserEmailActivity {
    <#
    .SYNOPSIS
        Retrieves email activity report for Microsoft 365 users.

    .DESCRIPTION
        Gets detailed email activity report for all users in the tenant for a specified period.
        Returns data such as send count, receive count, read count, and meeting activity.

    .PARAMETER Period
        The report period. Valid values are: D7, D30, D90, D180.
        Default is D180 (last 180 days).

    .EXAMPLE
        Get-OCM365UserEmailActivity
        Retrieves email activity for the last 180 days.

    .EXAMPLE
        Get-OCM365UserEmailActivity -Period D30
        Retrieves email activity for the last 30 days.

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
        Write-Debug "[Get-OCM365UserEmailActivity] Starting function with Period: $Period"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365UserEmailActivity] Successfully validated Graph connection"

        # Check required permissions
        $requiredScopes = @('Reports.Read.All')
        $currentScopes = $mgContext.Scopes
        Write-Debug "[Get-OCM365UserEmailActivity] Current scopes: $($currentScopes -join ', ')"

        $missingScopes = $requiredScopes | Where-Object { $_ -notin $currentScopes }
        if ($missingScopes) {
            $message = "Missing required permissions: $($missingScopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Information "Retrieving email activity report for period: $Period" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving email activity report for period: $Period" -Verbose:$VerbosePreference
        
        try {
            Write-Debug "[Get-OCM365UserEmailActivity] Calling Invoke-MgGraphRequest for email activity"
            
            $response = Invoke-MgGraphRequest `
                -Method GET `
                -Uri "https://graph.microsoft.com/v1.0/reports/getEmailActivityUserDetail(period='$Period')" `
                -OutputType HttpResponseMessage `
                -Verbose:$VerbosePreference `
                -Debug:$DebugPreference
            
            Write-Debug "[Get-OCM365UserEmailActivity] Converting CSV response"
            $csvContent = $response.Content.ReadAsStringAsync().Result
            $data = $csvContent | ConvertFrom-Csv
            
            Write-Information "Retrieved $($data.Count) email activity records" -InformationAction $InformationPreference
            Write-Verbose "Retrieved $($data.Count) records" -Verbose:$VerbosePreference
            return $data
        }
        catch {
            Write-Error "Failed to retrieve email activity report: $_" -ErrorAction Stop
            throw
        }
    }
}
