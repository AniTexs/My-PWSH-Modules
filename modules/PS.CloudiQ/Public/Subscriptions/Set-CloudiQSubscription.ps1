function Set-CloudiQSubscription {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        $SubscriptionId,
        [Parameter(Position = 1)]
        [int]
        $Add,
        [Parameter(Position = 2)]
        [int]
        $Subtract
    )
    process {
        if ($PSCmdlet.ShouldProcess("Cloud-iQ subscription $SubscriptionId", 'Update')) {
            # Get the Subscription First
            $Subscription = Get-CloudiQSubscription -Id $SubscriptionId
            if ($Add) {
                Write-Debug -Message "Adding $Add to quantity."
                [int]$subscription.quantity += $Add
            }
            elseif ($Subtract) {
                Write-Debug -Message "Subtracting $Subtract to quantity."
                [int]$subscription.quantity -= $Subtract
            }
            Invoke-Api -Path "/Subscriptions/$SubscriptionId" -Method Put -Payload ($subscription)
        }
    }
}
