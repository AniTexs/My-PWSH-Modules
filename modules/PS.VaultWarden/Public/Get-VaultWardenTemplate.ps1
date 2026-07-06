function Get-VaultWardenTemplate {
    <#
        .SYNOPSIS
        Returns a blank object template for creating vault items, folders, or collections.

        .DESCRIPTION
        Returns the expected JSON structure for the specified object type as a PowerShell object.
        Use this as a starting point for New-VaultWardenItem, New-VaultWardenFolder, etc.

        .PARAMETER Template
        The template type to retrieve. Valid values:
          item, item.field, item.login, item.login.uri, item.card,
          item.identity, item.securenote, folder, collection,
          item-collections, org-collection

        .EXAMPLE
        $template = Get-VaultWardenTemplate -Template item
        $template.name = 'My Login'
        $template.login.username = 'jdoe'
        $template.login.password = 'p@ssw0rd'
        New-VaultWardenItem -Item $template

        .EXAMPLE
        Get-VaultWardenTemplate -Template folder
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet(
            'item', 'item.field', 'item.login', 'item.login.uri', 'item.card',
            'item.identity', 'item.securenote', 'folder', 'collection',
            'item-collections', 'org-collection'
        )]
        [string]$Template
    )

    # bw get template returns {object:"template", template:{...actual object...}}
    # Return the inner template so callers can use it directly (e.g. $t.name = 'x').
    (Invoke-BW get template $Template).template
}
