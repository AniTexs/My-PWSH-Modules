function New-ACardRichTextBlock {
    <#
    .SYNOPSIS
    Creates an Adaptive Card RichTextBlock element.

    .DESCRIPTION
    Creates a rich text block that can contain multiple styled text runs.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Inlines
    Array of TextRun elements (created with New-ACardTextRun). Required.

    .PARAMETER HorizontalAlign
    Controls horizontal alignment of the text.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When true, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardRichTextBlock -Inlines @(
        New-ACardTextRun -Text "Bold text" -Weight Bolder
        New-ACardTextRun -Text " normal text"
    )
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Inlines,

        [PS.AdaptiveCard.Text+HorizontalAlignment]
        $HorizontalAlign,

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator
    )

    $ret = @{
        type    = "RichTextBlock"
        inlines = $Inlines
    }

    if ($Id) { $ret.id = $Id }
    if ($HorizontalAlign) { $ret.horizontalAlignment = $HorizontalAlign.ToString().ToLower() }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
