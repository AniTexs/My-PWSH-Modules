function Connect-Talentsoft {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $BaseUri,
        [Parameter(Mandatory)]
        [string]
        $ClientId,
        [Parameter(Mandatory)]
        [string]
        $ClientSecret
    )
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36"
    $body = @{
        grant_type    = "client_credentials"
        client_id     = $ClientId
        client_secret = $ClientSecret
    }
    $response = Invoke-RestMethod -Uri "$BaseUri/api/token" -Method Post -Body $body -WebSession $session
    $token = [TSApiToken]::new()
    $token.access_token = $response.access_token
    $token.token_type = $response.token_type
    $token.expires_in = $response.expires_in
    $token.scope = $response.scope

    $session.Headers["Authorization"] = "$($token.token_type) $($token.access_token)"

    $tsApiSession = [TSApiSession]::new()
    $tsApiSession.Token = $token
    $tsApiSession.WebSession = $session
    $tsApiSession.BaseUri = $BaseUri
    $tsApiSession.ApiBaseUri = "$BaseUri/api/v1.0"
    $tsApiSession.ClientId = $ClientId
    $tsApiSession.ClientSecret = $ClientSecret

    $Script:TSApiSession = $tsApiSession

    return $tsApiSession
}