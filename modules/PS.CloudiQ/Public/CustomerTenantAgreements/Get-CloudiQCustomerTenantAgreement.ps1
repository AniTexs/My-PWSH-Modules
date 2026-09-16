function Get-CloudiQCustomerTenantAgreement {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $CustomerTenantId,
        [Parameter(Mandatory)]
        [int]
        # AgreementTypeConsent enum: 0, 1
        $AgreementTypeConsent
    )
    process {
        $QueryParams = @{
            AgreementTypeConsent = $AgreementTypeConsent
        }
        (Invoke-Api -Path "/customertenants/$CustomerTenantId/agreements" -Query $QueryParams).Items
    }
}
