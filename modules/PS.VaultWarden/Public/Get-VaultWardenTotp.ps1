function Get-VaultWardenTotp {
    <#
        .SYNOPSIS
        Retrieves the current TOTP code for a vault item.

        .DESCRIPTION
        Returns the live one-time password for items that have a TOTP seed configured.

        .PARAMETER Id
        The UUID or search term for the item.

        .EXAMPLE
        Get-VaultWardenTotp -Id 'github'
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$Id
    )

    # bw get totp returns {"object":"string","data":"123456"}
    (Invoke-BW get totp $Id).data
}
