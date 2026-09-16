function Get-CloudiQAgreementReport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]
        $ProductContainerId
    )
    (Invoke-Api -Path "/AgreementReports/$ProductContainerId").Items
}
