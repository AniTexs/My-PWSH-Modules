function Unlock-VaultWarden {
    <#
        .SYNOPSIS
        Unlocks the Bitwarden vault and stores the resulting session key.

        .DESCRIPTION
        Unlocks the vault using the master password and saves the session key to
        the BW_SESSION environment variable for all subsequent commands.
        Falls back to the BW_MASTERPASSWORD environment variable if -MasterPassword is omitted.

        .PARAMETER MasterPassword
        The master password as a SecureString.
        Falls back to $env:BW_MASTERPASSWORD if not provided.

        .EXAMPLE
        Unlock-VaultWarden -MasterPassword $masterPwd
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [SecureString]$MasterPassword
    )

    # Fall back to the env var when no parameter is passed
    if (-not $MasterPassword -and $env:BW_MASTERPASSWORD) {
        $MasterPassword = ConvertTo-SecureString $env:BW_MASTERPASSWORD -AsPlainText -Force
    }

    if (-not $MasterPassword) {
        throw "Master password is required. Provide -MasterPassword or set `$env:BW_MASTERPASSWORD."
    }

    $state = Get-VWAuthentication
    if ($state -ne 'locked') {
        Write-Verbose "Vault is not locked (current state: $state). Nothing to unlock."
        return
    }

    if ($PSCmdlet.ShouldProcess('VaultWarden vault', 'Unlock')) {
        $env:BW_MASTERPASSWORD = $MasterPassword | ConvertFrom-SecureString -AsPlainText
        $response              = Invoke-BW unlock --passwordenv BW_MASTERPASSWORD
        $env:BW_SESSION        = $response.raw
        Write-Verbose $response.title
    }
}
