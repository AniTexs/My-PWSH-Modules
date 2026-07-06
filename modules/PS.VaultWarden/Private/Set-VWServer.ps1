function Set-VWServer {
    <#
        .SYNOPSIS
        Configures the Bitwarden CLI to point at the specified server URL.

        .PARAMETER Url
        The URL of the Bitwarden or self-hosted Vaultwarden server.

        .EXAMPLE
        Set-VWServer -Url 'https://vault.example.com'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Url
    )

    Invoke-BW config server $Url | Out-Null
}
