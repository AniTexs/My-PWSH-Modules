function Get-VaultWardenUsername {
    <#
        .SYNOPSIS
        Retrieves the username field of a vault item.

        .PARAMETER Id
        The UUID or search term for the item.

        .EXAMPLE
        Get-VaultWardenUsername -Id 'github'
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]$Id
    )

    # bw get username returns {"object":"string","data":"theusername"}
    (Invoke-BW get username $Id).data
}
