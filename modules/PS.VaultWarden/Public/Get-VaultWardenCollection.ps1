function Get-VaultWardenCollection {
    <#
        .SYNOPSIS
        Retrieves all collections accessible to the authenticated user.

        .DESCRIPTION
        Returns all personal and organization collections regardless of which
        organization they belong to. To scope to a specific organization, use
        Get-VaultWardenOrgCollection -OrganizationId instead.

        .EXAMPLE
        Get-VaultWardenCollection
    #>
    [CmdletBinding()]
    param()

    (Invoke-BW list collections).data
}
