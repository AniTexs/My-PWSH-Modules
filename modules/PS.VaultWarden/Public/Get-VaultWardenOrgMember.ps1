function Get-VaultWardenOrgMember {
    <#
        .SYNOPSIS
        Retrieves the members of a specific organization.

        .PARAMETER OrganizationId
        The UUID of the organization whose members to retrieve.

        .EXAMPLE
        Get-VaultWardenOrgMember -OrganizationId 'org-uuid-here'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$OrganizationId
    )

    (Invoke-BW list org-members --organizationid $OrganizationId).data
}
