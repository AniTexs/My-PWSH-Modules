function Get-CapaOneOrginazation {
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
        [Switch]$ListAvailable
    )
    if ($ListAvailable) {
        return $Script:CapaOneStructure.organizations
    }else{
        return $Script:CapaOneStructure.organizations | where { $_.id -eq $Script:CapaOneCurrentOrganizationId }
    }
}