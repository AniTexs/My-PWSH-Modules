function New-ACardTableColumnDefinition {
    <#
    .SYNOPSIS
    Creates a column definition for Table elements.

    .DESCRIPTION
    Defines the width for a table column.

    .PARAMETER Width
    Width of the column. Can be a number (relative weight) or "auto"/"stretch".

    .EXAMPLE
    New-ACardTableColumnDefinition -Width 2

    .EXAMPLE
    New-ACardTableColumnDefinition -Width "auto"
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [object]
        $Width = 1
    )

    @{
        width = $Width
    }
}
