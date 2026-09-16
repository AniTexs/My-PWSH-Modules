function Get-CloudiQSubscription {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [int]
        $Id,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $OrganizationId,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $CustomerTenantId,
        [Parameter(ParameterSetName = 'List')]
        [string]
        $PublisherCustomerId,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $PublisherId,
        [Parameter(ParameterSetName = 'List')]
        [string]
        $Search,
        [Parameter(ParameterSetName = 'List')]
        [bool]
        $IsTrial,
        [Parameter(ParameterSetName = 'List')]
        [int]
        # SubscriptionStatus flags: 1-active, 2-suspended, 4-deleted, 8-customerCancellation, 16-converted, 32-expired, 64-pending
        $Statuses,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $Page = 1,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $PageSize = 15
    )
    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        return Invoke-Api -Path "/Subscriptions/$Id"
    }
    $QueryParams = @{
        page     = $Page
        pageSize = $PageSize
    }
    if ($OrganizationId)      { $QueryParams.organizationId = $OrganizationId }
    if ($CustomerTenantId)    { $QueryParams.customerTenantId = $CustomerTenantId }
    if ($PublisherCustomerId) { $QueryParams.publisherCustomerId = $PublisherCustomerId }
    if ($PublisherId)         { $QueryParams.publisherId = $PublisherId }
    if ($Search)              { $QueryParams.search = $Search }
    if ($PSBoundParameters.ContainsKey('IsTrial'))  { $QueryParams.isTrial = $IsTrial }
    if ($PSBoundParameters.ContainsKey('Statuses')) { $QueryParams.statuses = $Statuses }

    (Invoke-Api -Path "/Subscriptions" -Query $QueryParams).Items
}
