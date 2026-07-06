function Get-GWAccount {
    [CmdletBinding()]
    param ()
    Invoke-GWRequest -Method Get -Path '/rest/me' -Url "https://gatewayapi.com/"
}