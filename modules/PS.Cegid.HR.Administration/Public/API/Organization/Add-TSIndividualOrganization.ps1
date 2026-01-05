function Add-TSIndividualOrganization {
    <#
    .SYNOPSIS
    Add an organization assignment to an individual.
    
    .DESCRIPTION
    Creates a new organization assignment for an individual with associated manager.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_ORGA
    
    .PARAMETER UserName
    The username of the individual.
    
    .PARAMETER OrganizationData
    Organization assignment data.
    
    .EXAMPLE
    Add-TSIndividualOrganization -UserName "jdoe" -OrganizationData @{ organizationCode = "ORG001"; managerEmployeeNumber = 11000 }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSOrganization])]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [hashtable]
        $OrganizationData
    )
    
    Write-Verbose "[Add-TSIndividualOrganization] Adding organization to individual $UserName"
    Write-Debug "[Add-TSIndividualOrganization] Data: $($OrganizationData | ConvertTo-Json)"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName", "Add organization")) {
        try {
            $body = $OrganizationData | ConvertTo-Json -Depth 5
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/organizations" -Method "POST" -Body @{ json = $body }
            Write-Verbose "[Add-TSIndividualOrganization] Successfully added organization"
            Write-Debug "[Add-TSIndividualOrganization] Added organization: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Add-TSIndividualOrganization] Failed to add organization: $_"
            throw
        }
    }
}