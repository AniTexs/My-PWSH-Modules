function New-ACardTableCell {
    <#
    .SYNOPSIS
    Creates a table cell for TableRow elements.

    .DESCRIPTION
    Creates a cell containing elements within a table row.

    .PARAMETER Items
    Array of elements to display in the cell. Required.

    .PARAMETER Style
    Visual style for the cell.

    .PARAMETER VerticalAlign
    Controls vertical alignment of content within the cell.

    .PARAMETER RowSpan
    Number of rows this cell should span.

    .PARAMETER ColumnSpan
    Number of columns this cell should span.

    .EXAMPLE
    New-ACardTableCell -Items @(
        New-ACardTextBlock -Text "Cell Content"
    )
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable[]]
        $Items,

        [PS.AdaptiveCard.Layout+ContainerStyle]
        $Style,

        [PS.AdaptiveCard.Layout+VerticalAlignment]
        $VerticalAlign,

        [int]
        $RowSpan,

        [int]
        $ColumnSpan
    )

    $ret = @{
        type  = "TableCell"
        items = $Items
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($VerticalAlign) { $ret.verticalContentAlignment = $VerticalAlign.ToString().ToLower() }
    if ($RowSpan) { $ret.rowSpan = $RowSpan }
    if ($ColumnSpan) { $ret.columnSpan = $ColumnSpan }

    $ret
}
