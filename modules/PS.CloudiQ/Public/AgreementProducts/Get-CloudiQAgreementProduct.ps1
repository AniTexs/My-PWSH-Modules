function Get-CloudiQAgreementProduct {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $AgreementId,
        [Parameter()]
        [int]
        $OrganizationId,
        [Parameter()]
        [int]
        $PriceListId,
        [Parameter()]
        [int[]]
        $AgreementIds,
        [Parameter()]
        [int[]]
        $AgreementTypeIds,
        [Parameter()]
        [string]
        $Search,
        [Parameter()]
        [datetime]
        $SearchDate,
        [Parameter()]
        [string[]]
        $Include,
        [Parameter()]
        [string[]]
        $Exclude,
        [Parameter()]
        [int]
        $Page = 1,
        [Parameter()]
        [int]
        $PageSize = 15,
        [Parameter()]
        [switch]
        # Send the filter as a POST body instead of query string (useful for large filters)
        $UsePost
    )
    $QueryParams = @{
        Page     = $Page
        PageSize = $PageSize
    }
    if ($AgreementId)      { $QueryParams.AgreementId = $AgreementId }
    if ($OrganizationId)   { $QueryParams.OrganizationId = $OrganizationId }
    if ($PriceListId)      { $QueryParams.PriceListId = $PriceListId }
    if ($AgreementIds)     { $QueryParams.AgreementIds = $AgreementIds }
    if ($AgreementTypeIds) { $QueryParams.AgreementTypeIds = $AgreementTypeIds }
    if ($Search)           { $QueryParams.Search = $Search }
    if ($SearchDate)       { $QueryParams.SearchDate = $SearchDate.ToString('o') }
    if ($Include)          { $QueryParams.Include = $Include }
    if ($Exclude)          { $QueryParams.Exclude = $Exclude }

    if ($UsePost) {
        return (Invoke-Api -Path "/AgreementProducts" -Method Post -Payload $QueryParams).Items
    }
    (Invoke-Api -Path "/AgreementProducts" -Query $QueryParams).Items
}
