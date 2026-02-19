function New-ACardDataQuery {
    <#
    .SYNOPSIS
    Creates a data query object for dynamic data binding.

    .DESCRIPTION
    Creates a Data.Query object for querying datasets in adaptive cards.

    .PARAMETER Dataset
    The name of the dataset to query. Required.

    .PARAMETER Count
    Number of records to retrieve.

    .PARAMETER Skip
    Number of records to skip.

    .EXAMPLE
    New-ACardDataQuery -Dataset "users" -Count "10" -Skip "0"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Dataset,

        [string]
        $Count,

        [string]
        $Skip
    )

    $ret = @{
        type    = "Data.Query"
        dataset = $Dataset
    }

    if ($Count) { $ret.count = $Count }
    if ($Skip) { $ret.skip = $Skip }

    $ret
}
