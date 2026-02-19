function New-ACardTable {
    <#
    .SYNOPSIS
    Creates an Adaptive Card Table element.

    .DESCRIPTION
    Creates a table with columns and rows for structured data display.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Columns
    Array of column definitions (created with New-ACardTableColumnDefinition). Required.

    .PARAMETER Rows
    Array of table rows (created with New-ACardTableRow). Required.

    .PARAMETER ShowGridLines
    When specified, displays grid lines between cells.

    .PARAMETER GridStyle
    Visual style for the grid lines.

    .PARAMETER FirstRowAsHeaders
    When specified, treats the first row as headers.

    .PARAMETER FirstRowAsHeadersStyle
    Style to apply when first row is treated as headers.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .PARAMETER TargetWidth
    Specifies the minimum target width (e.g., "AtLeast:Narrow", "AtLeast:Standard").

    .EXAMPLE
    New-ACardTable -Columns @(
        New-ACardTableColumnDefinition -Width 1
        New-ACardTableColumnDefinition -Width 2
    ) -Rows @(
        New-ACardTableRow -Cells @(
            New-ACardTableCell -Items @(New-ACardTextBlock -Text "Header 1")
            New-ACardTableCell -Items @(New-ACardTextBlock -Text "Header 2")
        )
    ) -FirstRowAsHeaders -ShowGridLines
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Columns,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Rows,

        [switch]
        $ShowGridLines,

        [PS.AdaptiveCard.Layout+ContainerStyle]
        $GridStyle,

        [switch]
        $FirstRowAsHeaders,

        [PS.AdaptiveCard.Layout+ContainerStyle]
        $FirstRowAsHeadersStyle,

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator,

        [string]
        $TargetWidth
    )

    $ret = @{
        type    = "Table"
        columns = $Columns
        rows    = $Rows
    }

    if ($Id) { $ret.id = $Id }
    if ($ShowGridLines.IsPresent) { $ret.showGridLines = $true }
    if ($GridStyle) { $ret.gridStyle = $GridStyle.ToString().ToLower() }
    if ($FirstRowAsHeaders.IsPresent) { $ret.firstRowAsHeaders = $true }
    if ($FirstRowAsHeadersStyle) { $ret.firstRowAsHeadersStyle = $FirstRowAsHeadersStyle.ToString().ToLower() }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }
    if ($TargetWidth) { $ret.targetWidth = $TargetWidth }

    $ret
}
