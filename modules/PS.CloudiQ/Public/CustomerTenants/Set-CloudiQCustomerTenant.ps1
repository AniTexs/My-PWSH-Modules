function Set-CloudiQCustomerTenant {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        $Id,
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]
        # CustomerTenantDetailed body with the values to update
        $InputObject
    )
    process {
        if ($PSCmdlet.ShouldProcess("Cloud-iQ customer tenant $Id", 'Update')) {
            Invoke-Api -Path "/CustomerTenants/$Id" -Method Put -Payload $InputObject
        }
    }
}
