function Remove-TSIndividualOrganization {
    <#
    .SYNOPSIS
    Remove an organization assignment from an individual.
    
    .DESCRIPTION
    Deletes an organization assignment.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_ORGA
    
    .PARAMETER UserName
    The username of the individual.
    
    .PARAMETER OrganizationCode
    The organization code to remove.
    
    .EXAMPLE
    Remove-TSIndividualOrganization -UserName "jdoe" -OrganizationCode "ORG001"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [string]
        $OrganizationCode
    )
    
    Write-Verbose "[Remove-TSIndividualOrganization] Removing organization $OrganizationCode from individual $UserName"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName - Org $OrganizationCode", "Remove")) {
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/organizations/$OrganizationCode" -Method "DELETE"
            Write-Verbose "[Remove-TSIndividualOrganization] Successfully removed organization"
            Write-Debug "[Remove-TSIndividualOrganization] Delete response: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Remove-TSIndividualOrganization] Failed to remove organization: $_"
            throw
        }
    }
}