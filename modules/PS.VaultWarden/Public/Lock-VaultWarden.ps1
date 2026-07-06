function Lock-VaultWarden {
    <#
        .SYNOPSIS
        Locks the Bitwarden vault and clears the active session key.

        .EXAMPLE
        Lock-VaultWarden
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if ($PSCmdlet.ShouldProcess('VaultWarden vault', 'Lock')) {
        $response       = Invoke-BW lock
        $env:BW_SESSION = $null
        Write-Verbose $response.title
    }
}
