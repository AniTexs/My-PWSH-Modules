function Get-CloudiQSubscriptionPrice {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        $Id
    )
    process {
        Invoke-Api -Path "/Subscriptions/$Id/price"
    }
}
