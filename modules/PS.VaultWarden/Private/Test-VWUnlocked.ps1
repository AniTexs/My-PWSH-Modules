function Test-VWUnlocked {
    <#
        .SYNOPSIS
        Returns $true if the Bitwarden vault is currently unlocked.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    (Get-VWAuthentication) -eq 'unlocked'
}
