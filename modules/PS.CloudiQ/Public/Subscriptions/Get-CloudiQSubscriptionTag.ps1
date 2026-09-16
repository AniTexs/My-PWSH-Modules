function Get-CloudiQSubscriptionTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        $SubscriptionId
    )
    process {
        Invoke-Api -Path "/Subscriptions/$SubscriptionId/tags"
    }
}
