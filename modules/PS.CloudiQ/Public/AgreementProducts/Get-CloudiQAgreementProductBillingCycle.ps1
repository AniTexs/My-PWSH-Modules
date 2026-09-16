function Get-CloudiQAgreementProductBillingCycle {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $PartNumber
    )
    process {
        Invoke-Api -Path "/AgreementProducts/$PartNumber/supportedbillingcycles"
    }
}
