function New-ACardTextBlock {
    [CmdletBinding()]
    param (
        [string]
        $Id,
        [Parameter(Mandatory)]
        [string]
        $Text,

        # Layout
        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing = [PS.AdaptiveCard.Layout+Spacing]::Default,
        [Switch]
        $Separator,
        [PS.AdaptiveCard.Layout+HorizontalAlignment]
        $HorizontalAlign,
        [PS.AdaptiveCard.Layout+Height]
        $Height = [PS.AdaptiveCard.Layout+Height]::Auto,
        [switch]
        $Wrap,
        [int]
        $MaxLines = 0,

        # Style
        [PS.AdaptiveCard.Text+BaseStyle]
        $Style,
        [PS.AdaptiveCard.Text+FontType]
        $Font,
        [PS.AdaptiveCard.Text+FontSize]
        $Size,
        [PS.AdaptiveCard.Text+FontWeight]
        $Weight,
        [PS.AdaptiveCard.Text+FontColor]
        $Color,
        [Switch]
        $Subtle
    )
    $ret = @{
        type      = "TextBlock"
        text      = $Text
        wrap      = $Wrap.IsPresent
        spacing   = $Spacing.ToString()
        separator = $Separator.IsPresent
        height    = $Height.ToString().ToLower()
        maxLines  = $MaxLines
    }
    if ($Id) { $ret.id = $Id }
    if ($HorizontalAlign) { $ret.horizontalAlignment = $HorizontalAlign.ToString() }
    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($Font) { $ret.fontType = $Font.ToString().ToLower() }
    if ($Size) { $ret.size = $Size.ToString().ToLower() }
    if ($Weight) { $ret.weight = $Weight.ToString().ToLower() }
    if ($Color) { $ret.color = $Color.ToString().ToLower() }
    if ($Subtle.IsPresent) { $ret.isSubtle = $true }
    $ret
}