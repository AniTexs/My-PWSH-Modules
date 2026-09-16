function Get-CloudiQActivityLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        # Entity name to fetch logs for, e.g. 'Organization', 'CustomerTenant', 'Subscription'
        $Entity,
        [Parameter(Mandatory)]
        [int]
        $Id,
        [Parameter()]
        [datetime]
        $SearchDate,
        [Parameter()]
        [datetime]
        $From,
        [Parameter()]
        [datetime]
        $To,
        [Parameter()]
        [int]
        $Page = 1,
        [Parameter()]
        [int]
        $PageSize = 15
    )
    $QueryParams = @{
        entity   = $Entity
        id       = $Id
        page     = $Page
        pageSize = $PageSize
    }
    if ($SearchDate) { $QueryParams.searchDate = $SearchDate.ToString('o') }
    if ($From)       { $QueryParams.from = $From.ToString('o') }
    if ($To)         { $QueryParams.to = $To.ToString('o') }

    (Invoke-Api -Path "/ActivityLogs" -Query $QueryParams).Items
}
