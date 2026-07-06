function Get-VaultWardenOrgCollection {
    <#
        .SYNOPSIS
        Retrieves collections belonging to a specific organization.

        .PARAMETER OrganizationId
        The UUID of the organization whose collections to retrieve.

        .EXAMPLE
        Get-VaultWardenOrgCollection -OrganizationId 'org-uuid-here'

        .EXAMPLE
        Get-VaultWardenOrganization | Select-Object -First 1 | ForEach-Object { Get-VaultWardenOrgCollection -OrganizationId $_.id }
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$OrganizationId
    )

    (Invoke-BW list org-collections --organizationid $OrganizationId).data
}
