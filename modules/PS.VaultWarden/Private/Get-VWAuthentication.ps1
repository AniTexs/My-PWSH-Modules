function Get-VWAuthentication {
    <#
        .SYNOPSIS
        Returns the current Bitwarden CLI authentication/lock state.

        .DESCRIPTION
        Returns one of three string values: 'unlocked', 'locked', or 'unauthenticated'.
    #>
    [CmdletBinding()]
    param()

    (Get-VWStatus).status
}
