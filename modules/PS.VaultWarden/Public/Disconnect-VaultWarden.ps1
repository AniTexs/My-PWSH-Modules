function Disconnect-VaultWarden {
    <#
        .SYNOPSIS
        Logs out of the Bitwarden CLI and clears all session and credential environment variables.

        .EXAMPLE
        Disconnect-VaultWarden
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if ($PSCmdlet.ShouldProcess('VaultWarden', 'Disconnect')) {
        $response = Invoke-BW logout
        Write-Verbose $response.title
        $env:BW_SESSION      = $null
        $env:BW_CLIENTID     = $null
        $env:BW_CLIENTSECRET = $null
    }
}
