function Confirm-VaultWardenOrgMember {
    <#
        .SYNOPSIS
        Confirms a pending organization member invitation.

        .DESCRIPTION
        Confirms a user who has accepted an organization invite.
        Always validate the member's fingerprint phrase before confirming to ensure
        the request is legitimate.

        .PARAMETER Id
        The UUID of the member to confirm.

        .PARAMETER OrganizationId
        The UUID of the organization.

        .EXAMPLE
        Confirm-VaultWardenOrgMember -Id 'member-uuid' -OrganizationId 'org-uuid'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$OrganizationId
    )

    if ($PSCmdlet.ShouldProcess($Id, "Confirm organization member in '$OrganizationId'")) {
        Invoke-BW confirm org-member $Id --organizationid $OrganizationId
    }
}
