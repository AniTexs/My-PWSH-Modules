function Invoke-GWRequest {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,
        $Url = "",
        [ValidateSet("Global", "EU")]
        $Endpoint = "Global",
        [SecureString]
        $Token = $script:GWToken,
        [Parameter(Mandatory)]
        [String]
        $Path,
        [Hashtable]
        $Body
    )
    if(-not $Token) {
        $Token = $script:GWToken
    }
    if(-not $Token) {
        throw "No token provided. Please set the token using Set-GWToken or provide it as a parameter."
    }
    if(-not $Url) {
        $TLD = $Endpoint -eq "Global" ? 'com' : 'eu'
        $Url = "https://messaging.gatewayapi.$TLD/$($Path.TrimStart('/'))"
    }else{
        $Url = @($Url.Trim('/'),$Path.Trim('/')) -join '/'
    }
    $RequestParam = @{
        Uri         = $Url
        Method      = $Method
    }
    if ($Body) {
        $RequestParam.Body = $Body | ConvertTo-Json
        $RequestParam.ContentType = "application/json"
    }
    Write-Host "Performing Request against url: $($RequestParam.Uri)"
    Invoke-RestMethod @RequestParam -Headers @{
        Authorization = "Token $($Token | ConvertFrom-SecureString -AsPlainText)"
        Accept = "application/json"
    }
}