function Move-VaultWardenItem {
    <#
        .SYNOPSIS
        Moves a personal vault item to an organization collection.

        .DESCRIPTION
        Transfers ownership of a vault item to an organization and assigns it to one
        or more collections within that organization.

        .PARAMETER Id
        The UUID of the item to move.

        .PARAMETER OrganizationId
        The UUID of the target organization.

        .PARAMETER CollectionIds
        One or more collection UUIDs within the organization to assign the item to.

        .EXAMPLE
        Move-VaultWardenItem -Id 'item-uuid' -OrganizationId 'org-uuid' -CollectionIds 'col-uuid'

        .EXAMPLE
        Move-VaultWardenItem -Id 'item-uuid' -OrganizationId 'org-uuid' -CollectionIds @('col-uuid-1', 'col-uuid-2')
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$OrganizationId,

        [Parameter(Mandatory)]
        [string[]]$CollectionIds
    )

    if ($PSCmdlet.ShouldProcess($Id, "Move vault item to organization '$OrganizationId'")) {
        $encoded = ConvertTo-BwEncodedJson -InputObject $CollectionIds
        Invoke-BW move $Id $OrganizationId $encoded
    }
}
