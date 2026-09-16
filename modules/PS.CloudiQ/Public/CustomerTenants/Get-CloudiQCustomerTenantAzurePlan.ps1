function Get-CloudiQCustomerTenantAzurePlan {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $CustomerTenantId
    )
    process {
        Invoke-Api -Path "/CustomerTenants/$CustomerTenantId/azurePlan"
    }
}
