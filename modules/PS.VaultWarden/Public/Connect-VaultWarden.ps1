function Connect-VaultWarden {
    <#
        .SYNOPSIS
        Authenticates to a Bitwarden/Vaultwarden server using an API key.

        .DESCRIPTION
        Configures the server URL, stores the API key credentials as environment variables,
        and logs in via the Bitwarden CLI. Optionally unlocks the vault in the same call.

        .PARAMETER Url
        The URL of the Bitwarden or self-hosted Vaultwarden server.

        .PARAMETER ClientId
        The personal API key client_id.

        .PARAMETER ClientSecret
        The personal API key client_secret as a SecureString.

        .PARAMETER MasterPassword
        The master password used to unlock the vault. Required when -Unlock is specified.

        .PARAMETER Unlock
        When specified, unlocks the vault immediately after authenticating.

        .EXAMPLE
        Connect-VaultWarden -Url 'https://vault.example.com' -ClientId 'user.xxx' -ClientSecret $secret

        .EXAMPLE
        Connect-VaultWarden -Url 'https://vault.example.com' -ClientId 'user.xxx' -ClientSecret $secret -Unlock -MasterPassword $master
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter(Mandatory)]
        [string]$ClientId,

        [Parameter(Mandatory)]
        [SecureString]$ClientSecret,

        [Parameter()]
        [SecureString]$MasterPassword,

        [Parameter()]
        [switch]$Unlock
    )

    if ($PSCmdlet.ShouldProcess($Url, 'Connect to VaultWarden')) {
        Set-VWServer -Url $Url
        $env:BW_CLIENTID     = $ClientId
        $env:BW_CLIENTSECRET = $ClientSecret | ConvertFrom-SecureString -AsPlainText

        $state = Get-VWAuthentication
        if ($state -eq 'unauthenticated') {
            $response = Invoke-BW login --apikey
            Write-Verbose $response.title
        }

        if ($Unlock) {
            if (-not $MasterPassword) {
                throw 'MasterPassword is required when -Unlock is specified.'
            }
            Unlock-VaultWarden -MasterPassword $MasterPassword
        }
    }
}