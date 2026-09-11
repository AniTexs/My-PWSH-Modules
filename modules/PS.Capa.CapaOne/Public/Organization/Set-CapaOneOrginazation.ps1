function Set-CapaOneOrginazation {
    <#
    .SYNOPSIS
    Template example for creating new CapaOne functions.
    .DESCRIPTION
    Demonstrates the structure of a function that calls the CapaOne API.
    .EXAMPLE
    PS> FunctionName
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [string]
        $Id
    )
    $AvailableOrgs = $Script:CapaOneStructure.organizations
    $SelectedOrg = $AvailableOrgs | where { $_.id -eq $Id }
    if ($SelectedOrg) {
        $Script:CapaOneCurrentOrganizationId = $SelectedOrg.id
    } else {
        throw "Organization with ID '$Id' not found."
    }
}