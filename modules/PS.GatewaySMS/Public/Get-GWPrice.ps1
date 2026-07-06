function Get-GWPrice {
    [CmdletBinding()]
    param ()
    Invoke-GWRequest -Method Get -Path '/api/prices/list/sms/json' -Url "https://gatewayapi.com/"
}