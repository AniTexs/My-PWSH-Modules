function New-ACardTableRow {
    <#
    .SYNOPSIS
    Creates a table row for Table elements.

    .DESCRIPTION
    Creates a row containing table cells.

    .PARAMETER Cells
    Array of table cells (created with New-ACardTableCell). Required.

    .PARAMETER Style
    Visual style for the row.

    .EXAMPLE
    New-ACardTableRow -Cells @(
        New-ACardTableCell -Items @(New-ACardTextBlock -Text "Cell 1")
        New-ACardTableCell -Items @(New-ACardTextBlock -Text "Cell 2")
    )
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable[]]
        $Cells,

        [PS.AdaptiveCard.Layout+ContainerStyle]
        $Style
    )

    $ret = @{
        type  = "TableRow"
        cells = $Cells
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }

    $ret
}
