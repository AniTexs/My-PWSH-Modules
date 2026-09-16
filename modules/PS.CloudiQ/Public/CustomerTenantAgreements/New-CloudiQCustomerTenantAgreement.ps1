function New-CloudiQCustomerTenantAgreement {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $CustomerTenantId,
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]
        # ServiceAccountAgreement body to consent to
        $InputObject
    )
    process {
        if ($PSCmdlet.ShouldProcess("customer tenant $CustomerTenantId", 'Consent agreement')) {
            Invoke-Api -Path "/customertenants/$CustomerTenantId/agreements" -Method Post -Payload $InputObject
        }
    }
}
