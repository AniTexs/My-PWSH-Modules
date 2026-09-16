function New-CloudiQSubscription {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]
        # Subscription body to create
        $InputObject
    )
    process {
        if ($PSCmdlet.ShouldProcess('Cloud-iQ subscription', 'Create')) {
            Invoke-Api -Path "/Subscriptions" -Method Post -Payload $InputObject
        }
    }
}
