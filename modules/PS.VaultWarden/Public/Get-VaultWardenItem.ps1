function Get-VaultWardenItem {
    <#
        .SYNOPSIS
        Retrieves a single vault item or a filtered list of vault items.

        .DESCRIPTION
        When -Id is provided, returns a single item by its UUID or search term (bw get item).
        Without -Id, returns all items matching the supplied filters (bw list items).

        .PARAMETER Id
        UUID or search term for a single item.

        .PARAMETER Search
        Searches items by string.

        .PARAMETER FolderId
        Filters items by folder UUID. Pass 'null' for items with no folder assignment.

        .PARAMETER CollectionId
        Filters items by collection UUID. Pass 'null' for items with no collection assignment.

        .PARAMETER OrganizationId
        Filters items by organization UUID.

        .PARAMETER Url
        Filters items matching a specific URI.

        .PARAMETER Trash
        Returns items currently in the trash.

        .EXAMPLE
        Get-VaultWardenItem -Id 'abc123'

        .EXAMPLE
        Get-VaultWardenItem -Search 'github'

        .EXAMPLE
        Get-VaultWardenItem -Search 'github' -FolderId 'null'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single', Position = 0)]
        [string]$Id,

        [Parameter(ParameterSetName = 'List')]
        [string]$Search,

        [Parameter(ParameterSetName = 'List')]
        [string]$FolderId,

        [Parameter(ParameterSetName = 'List')]
        [string]$CollectionId,

        [Parameter(ParameterSetName = 'List')]
        [string]$OrganizationId,

        [Parameter(ParameterSetName = 'List')]
        [string]$Url,

        [Parameter(ParameterSetName = 'List')]
        [switch]$Trash
    )

    if ($PSCmdlet.ParameterSetName -eq 'Single') {
        Invoke-BW get item $Id
    }
    else {
        $bwArgs = [System.Collections.Generic.List[string]]@('list', 'items')
        if ($Search)         { $bwArgs.AddRange([string[]]@('--search', $Search)) }
        if ($FolderId)       { $bwArgs.AddRange([string[]]@('--folderid', $FolderId)) }
        if ($CollectionId)   { $bwArgs.AddRange([string[]]@('--collectionid', $CollectionId)) }
        if ($OrganizationId) { $bwArgs.AddRange([string[]]@('--organizationid', $OrganizationId)) }
        if ($Url)            { $bwArgs.AddRange([string[]]@('--url', $Url)) }
        if ($Trash)          { $bwArgs.Add('--trash') }

        (Invoke-BW @bwArgs).data
    }
}
