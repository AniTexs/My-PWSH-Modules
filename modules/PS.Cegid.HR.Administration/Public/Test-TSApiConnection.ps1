function Test-TSApiConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [TSApiSession]
        $tsApiSession
    )
    Write-Verbose "[Test-TSApiConnection] Testing Talentsoft API connection"
    Write-Debug "[Test-TSApiConnection] BaseUri: $($tsApiSession.BaseUri)"
    Write-Debug "[Test-TSApiConnection] ApiBaseUri: $($tsApiSession.ApiBaseUri)"
    
    try {
        $ApiUri = $tsApiSession.ApiBaseUri + "/directory"
        Write-Debug "[Test-TSApiConnection] Test endpoint: $ApiUri"
        Write-Verbose "[Test-TSApiConnection] Sending GET request to /directory endpoint"
        
        Invoke-RestMethod -Uri $ApiUri -Method "GET" -WebSession $tsApiSession.WebSession -ContentType "application/json" -ErrorAction Stop | Out-Null
        
        Write-Verbose "[Test-TSApiConnection] Connection test successful"
        Write-Debug "[Test-TSApiConnection] API is responsive - returning true"
        return $true
    }
    catch {
        Write-Verbose "[Test-TSApiConnection] Connection test failed"
        Write-Debug "[Test-TSApiConnection] Error: $($_.Exception.Message)"
        Write-Debug "[Test-TSApiConnection] Error type: $($_.Exception.GetType().FullName)"
        if ($_.Exception.Response) {
            Write-Debug "[Test-TSApiConnection] HTTP Status Code: $($_.Exception.Response.StatusCode.value__)"
        }
        return $false
    }
}