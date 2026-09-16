function Add-CloudiQExistingCustomerTenant {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]
        # CustomerTenantDetailed body describing the existing tenant to link
        $InputObject
    )
    process {
        if ($PSCmdlet.ShouldProcess('Existing Cloud-iQ customer tenant', 'Add')) {
            Invoke-Api -Path "/CustomerTenants/existing" -Method Post -Payload $InputObject
        }
    }
}
