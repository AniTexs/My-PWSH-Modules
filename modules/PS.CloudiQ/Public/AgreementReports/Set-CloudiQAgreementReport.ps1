function Set-CloudiQAgreementReport {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        $AgreementId,
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]
        # AgreementReport body to submit
        $InputObject
    )
    process {
        if ($PSCmdlet.ShouldProcess("AgreementReport for agreement $AgreementId", 'Update')) {
            Invoke-Api -Path "/AgreementReports/$AgreementId" -Method Put -Payload $InputObject
        }
    }
}
