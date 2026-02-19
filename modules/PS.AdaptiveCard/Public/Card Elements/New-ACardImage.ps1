function New-ACardImage {
    <#
    .SYNOPSIS
    Creates an Adaptive Card Image element.

    .DESCRIPTION
    Creates an image element for an Adaptive Card with various display options and styling.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Url
    The URL to the image. Required.

    .PARAMETER AltText
    Alternate text for the image for accessibility.

    .PARAMETER Size
    Controls the size of the image. Options: Auto, Stretch, Small, Medium, Large.

    .PARAMETER HorizontalAlign
    Controls horizontal alignment of the image.

    .PARAMETER BackgroundColor
    Background color for transparent images.

    .PARAMETER Style
    Display style for the image (Default or Person for circular cropping).

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When true, draw a separating line at the top of the element.

    .PARAMETER Height
    Specifies the height of the element.

    .EXAMPLE
    New-ACardImage -Url "https://example.com/image.png" -AltText "Example Image" -Size Medium
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [string]
        $Url,

        [string]
        $AltText,

        [ValidateSet("Auto", "Stretch", "Small", "Medium", "Large")]
        [string]
        $Size = "Auto",

        [PS.AdaptiveCard.Text+HorizontalAlignment]
        $HorizontalAlign,

        [string]
        $BackgroundColor,

        [ValidateSet("Default", "Person")]
        [string]
        $Style = "Default",

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator,

        [PS.AdaptiveCard.Layout+Height]
        $Height
    )

    $ret = @{
        type    = "Image"
        url     = $Url
        size    = $Size.ToLower()
        style   = $Style.ToLower()
    }

    if ($Id) { $ret.id = $Id }
    if ($AltText) { $ret.altText = $AltText }
    if ($HorizontalAlign) { $ret.horizontalAlignment = $HorizontalAlign.ToString().ToLower() }
    if ($BackgroundColor) { $ret.backgroundColor = $BackgroundColor }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }
    if ($Height) { $ret.height = $Height.ToString().ToLower() }

    $ret
}
