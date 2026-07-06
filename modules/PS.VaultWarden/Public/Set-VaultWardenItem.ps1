function Set-VaultWardenItem {
    <#
        .SYNOPSIS
        Updates an existing vault item.

        .DESCRIPTION
        Takes a modified item object and saves the changes back to the vault.
        Retrieve the current item with Get-VaultWardenItem, modify the properties,
        then pass the modified object to this function.

        .PARAMETER Id
        The UUID of the item to update.

        .PARAMETER Item
        The modified item object to save back to the vault.

        .EXAMPLE
        $item = Get-VaultWardenItem -Id 'abc123'
        $item.login.password = 'newP@ssw0rd'
        Set-VaultWardenItem -Id $item.id -Item $item

        .EXAMPLE
        $item = Get-VaultWardenItem -Id 'abc123'
        $item.name = 'Renamed Item'
        $item | Set-VaultWardenItem -Id $item.id
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Item
    )

    process {
        if ($PSCmdlet.ShouldProcess($Id, 'Update vault item')) {
            $encoded = ConvertTo-BwEncodedJson -InputObject $Item
            Invoke-BW edit item $Id $encoded
        }
    }
}
