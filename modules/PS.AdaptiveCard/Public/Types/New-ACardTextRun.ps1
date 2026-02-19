function New-ACardTextRun {
    <#
    .SYNOPSIS
    Creates a TextRun for use in RichTextBlock elements.

    .DESCRIPTION
    Creates a styled text run that can be used within a RichTextBlock.

    .PARAMETER Text
    The text content. Required.

    .PARAMETER Size
    Font size for the text.

    .PARAMETER Weight
    Font weight (thickness) for the text.

    .PARAMETER Color
    Color of the text.

    .PARAMETER Subtle
    When specified, displays the text in a subtle/muted style.

    .PARAMETER Italic
    When specified, displays the text in italic style.

    .PARAMETER Strikethrough
    When specified, displays the text with strikethrough.

    .PARAMETER Underline
    When specified, displays the text underlined.

    .PARAMETER Highlight
    When specified, highlights the text.

    .EXAMPLE
    New-ACardTextRun -Text "Important" -Weight Bolder -Color Attention
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Text,

        [PS.AdaptiveCard.Text+FontSize]
        $Size,

        [PS.AdaptiveCard.Text+FontWeight]
        $Weight,

        [PS.AdaptiveCard.Text+FontColor]
        $Color,

        [switch]
        $Subtle,

        [switch]
        $Italic,

        [switch]
        $Strikethrough,

        [switch]
        $Underline,

        [switch]
        $Highlight
    )

    $ret = @{
        type = "TextRun"
        text = $Text
    }

    if ($Size) { $ret.size = $Size.ToString().ToLower() }
    if ($Weight) { $ret.weight = $Weight.ToString().ToLower() }
    if ($Color) { $ret.color = $Color.ToString().ToLower() }
    if ($Subtle.IsPresent) { $ret.subtle = $true }
    if ($Italic.IsPresent) { $ret.italic = $true }
    if ($Strikethrough.IsPresent) { $ret.strikethrough = $true }
    if ($Underline.IsPresent) { $ret.underline = $true }
    if ($Highlight.IsPresent) { $ret.highlight = $true }

    $ret
}
