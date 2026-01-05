function Update-TSIndividualOrganization {
    <#
    .SYNOPSIS
    Update an organization assignment for an individual.
    
    .DESCRIPTION
    Changes the manager for an individual in a specific organization.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_ORGA
    
    .PARAMETER UserName
    The username of the individual.
    
    .PARAMETER OrganizationCode
    The organization code.
    
    .PARAMETER OrganizationData
    Updated organization data.
    
    .EXAMPLE
    Update-TSIndividualOrganization -UserName "jdoe" -OrganizationCode "ORG001" -OrganizationData @{ managerEmployeeNumber = 11002 }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSOrganization])]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [string]
        $OrganizationCode,
        
        [Parameter(Mandatory)]
        [hashtable]
        $OrganizationData
    )
    
    Write-Verbose "[Update-TSIndividualOrganization] Updating organization $OrganizationCode for individual $UserName"
    Write-Debug "[Update-TSIndividualOrganization] Update data: $($OrganizationData | ConvertTo-Json)"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName - Org $OrganizationCode", "Update")) {
        try {
            $body = $OrganizationData | ConvertTo-Json -Depth 5
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/organizations/$OrganizationCode" -Method "PUT" -Body @{ json = $body }
            Write-Verbose "[Update-TSIndividualOrganization] Successfully updated organization"
            Write-Debug "[Update-TSIndividualOrganization] Updated organization: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Update-TSIndividualOrganization] Failed to update organization: $_"
            throw
        }
    }
}