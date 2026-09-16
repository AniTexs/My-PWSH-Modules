function New-CloudiQCustomerTenant {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]
        # CustomerTenantDetailed body to create
        $InputObject
    )
    process {
        if ($PSCmdlet.ShouldProcess('Cloud-iQ customer tenant', 'Create')) {
            Invoke-Api -Path "/CustomerTenants" -Method Post -Payload $InputObject
        }
    }
}
