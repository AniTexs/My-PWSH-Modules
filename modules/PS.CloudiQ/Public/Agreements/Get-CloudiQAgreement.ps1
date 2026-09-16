function Get-CloudiQAgreement {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $OrganizationId,
        [Parameter()]
        [int]
        $PublisherId,
        [Parameter()]
        [int[]]
        $PublisherIds,
        [Parameter()]
        [int[]]
        $AgreementIds,
        [Parameter()]
        [string]
        $Search,
        [Parameter()]
        [bool]
        $IsTrial,
        [Parameter()]
        [int]
        # AgreementStatus enum value
        $Status,
        [Parameter()]
        [int[]]
        # AgreementType enum values
        $AgreementTypes,
        [Parameter()]
        [datetime]
        $SearchDate,
        [Parameter()]
        [int[]]
        $PriceListIds,
        [Parameter()]
        [string]
        $SalesPriceCurrency,
        [Parameter()]
        [bool]
        $TermRequired,
        [Parameter()]
        [datetime]
        $EndDateFrom,
        [Parameter()]
        [datetime]
        $EndDateTo,
        [Parameter()]
        [int]
        $Page = 1,
        [Parameter()]
        [int]
        $PageSize = 15
    )
    $QueryParams = @{
        page     = $Page
        pageSize = $PageSize
    }
    if ($OrganizationId)    { $QueryParams.organizationId = $OrganizationId }
    if ($PublisherId)       { $QueryParams.publisherId = $PublisherId }
    if ($PublisherIds)      { $QueryParams.publisherIds = $PublisherIds }
    if ($AgreementIds)      { $QueryParams.agreementIds = $AgreementIds }
    if ($Search)            { $QueryParams.search = $Search }
    if ($PSBoundParameters.ContainsKey('IsTrial'))      { $QueryParams.isTrial = $IsTrial }
    if ($PSBoundParameters.ContainsKey('Status'))       { $QueryParams.status = $Status }
    if ($AgreementTypes)    { $QueryParams.agreementTypes = $AgreementTypes }
    if ($SearchDate)        { $QueryParams.searchDate = $SearchDate.ToString('o') }
    if ($PriceListIds)      { $QueryParams.priceListIds = $PriceListIds }
    if ($SalesPriceCurrency){ $QueryParams.salesPriceCurrency = $SalesPriceCurrency }
    if ($PSBoundParameters.ContainsKey('TermRequired')) { $QueryParams.termRequired = $TermRequired }
    if ($EndDateFrom)       { $QueryParams.endDateFrom = $EndDateFrom.ToString('o') }
    if ($EndDateTo)         { $QueryParams.endDateTo = $EndDateTo.ToString('o') }

    (Invoke-Api -Path "/Agreements" -Query $QueryParams).Items
}
