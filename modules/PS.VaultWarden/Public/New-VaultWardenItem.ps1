function New-VaultWardenItem {
    <#
        .SYNOPSIS
        Creates a new item in the Bitwarden vault.

        .DESCRIPTION
        Accepts a hashtable or PSCustomObject representing the item, JSON-encodes it,
        and creates it in the vault. Use Get-VaultWardenTemplate to obtain the required
        object structure for each item type.

        Item types: 1 = Login, 2 = Secure Note, 3 = Card, 4 = Identity, 5 = SSH Key

        .PARAMETER Item
        A hashtable or PSCustomObject representing the vault item to create.

        .EXAMPLE
        $template = Get-VaultWardenTemplate -Template item
        $template.name = 'My Login'
        $template.login.username = 'user@example.com'
        $template.login.password = 'p@ssw0rd'
        New-VaultWardenItem -Item $template

        .EXAMPLE
        $template | New-VaultWardenItem
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$Item
    )

    process {
        if ($PSCmdlet.ShouldProcess($Item.name, 'Create vault item')) {
            $encoded = ConvertTo-BwEncodedJson -InputObject $Item
            Invoke-BW create item $encoded
        }
    }
}
