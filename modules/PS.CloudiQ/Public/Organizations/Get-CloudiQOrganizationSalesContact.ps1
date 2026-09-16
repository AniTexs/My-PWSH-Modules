function Get-CloudiQOrganizationSalesContact {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]
        $OrganizationId
    )
    Invoke-Api -Path "/organizations/$OrganizationId/salescontact"
}
