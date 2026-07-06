function Set-VaultWardenFolder {
    <#
        .SYNOPSIS
        Renames a vault folder.

        .PARAMETER Id
        The UUID of the folder to rename.

        .PARAMETER Name
        The new name for the folder.

        .EXAMPLE
        Set-VaultWardenFolder -Id 'abc123' -Name 'Personal'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess($Id, "Rename vault folder to '$Name'")) {
        $encoded = ConvertTo-BwEncodedJson -InputObject @{ name = $Name }
        Invoke-BW edit folder $Id $encoded
    }
}
