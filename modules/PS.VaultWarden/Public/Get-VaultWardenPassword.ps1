function Get-VaultWardenPassword {
    <#
        .SYNOPSIS
        Retrieves the password field of a vault item.

        .PARAMETER Id
        The UUID or search term for the item.

        .EXAMPLE
        Get-VaultWardenPassword -Id 'github'
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$Id
    )

    # bw get password returns {"object":"string","data":"thepassword"}
    (Invoke-BW get password $Id).data
}
