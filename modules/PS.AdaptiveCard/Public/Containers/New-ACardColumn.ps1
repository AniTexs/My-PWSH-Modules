#TODO: Follow Schema
function New-ACardColumn {
    [CmdletBinding(DefaultParameterSetName = "Stretch")]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Items,

        [Parameter(ParameterSetName = "AutoWidth")]
        [Switch]
        $AutomaticWidth,
        [Parameter(ParameterSetName = "StretchWidth")]
        [Switch]
        $StretchWidth,
        [Parameter(ParameterSetName = "WeightedWidth")]
        [Switch]
        $WeightedWidth,
        [Parameter(ParameterSetName = "PixelsWidth")]
        [Switch]
        $PixelsWidth,
        [ValidateRange(1, 1000)]
        [Parameter(ParameterSetName = "WeightedWidth")]
        [Parameter(ParameterSetName = "PixelsWidth")]
        [int]
        $WidthValue = 50,

        [PS.AdaptiveCard.Layout+Height]
        $Height = [PS.AdaptiveCard.Layout+Height]::Auto,
        [int]
        $MinimumPixelHeight,

        [PS.AdaptiveCard.Layout+VerticalAlignment]
        $VerticalAlign,

        [switch]
        $RightToLeft,

        [switch]
        $Seperator,

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing

    )
    switch ($PsCmdlet.ParameterSetName) {
        "AutoWidth" { $Width = "Automatic" }
        "WeightedWidth" { $Width = "$($WidthValue)" }
        "PixelsWidth" { $Width = "$($WidthValue)px" }
        Default {
            $Width = "stretch"
        }
    }
    $ret = @{
        type   = "Column"
        width  = $Width
        items  = $Items
        height = $Height.ToString().ToLower()
    }
    if ($Id) { $ret.id = $Id }
    if ($RightToLeft.IsPresent) { $ret.rtl = $true }
    if ($VerticalAlign) { $ret.verticalContentAlignment = $VerticalAlign.ToString() }
    if ($MinimumPixelHeight) { $ret.minHeight = "$($MinimumPixelHeight)px" }
    if ($Seperator.IsPresent) { $ret.separator = $true }
    if ($Spacing) { $ret.spacing = $Spacing }
    $ret
}