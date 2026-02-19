function New-ACardContainer {
    <#
    .SYNOPSIS
    Creates an Adaptive Card Container element.

    .DESCRIPTION
    Creates a container that groups elements together with optional styling and background.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Items
    Array of elements to include in the container. Required.

    .PARAMETER Style
    Visual style for the container (emphasis, good, attention, warning, accent).

    .PARAMETER VerticalAlign
    Controls vertical alignment of items within the container.

    .PARAMETER Bleed
    When specified, allows the container to bleed to the edge of its parent.

    .PARAMETER BackgroundImage
    Background image for the container (created with New-ACardBackgroundImage).

    .PARAMETER MinHeight
    Minimum height in pixels for the container.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .PARAMETER Height
    Specifies the height of the element.

    .EXAMPLE
    New-ACardContainer -Items @(
        New-ACardTextBlock -Text "Container Title" -Weight Bolder
        New-ACardTextBlock -Text "Container content"
    ) -Style Emphasis
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Items,

        [PS.AdaptiveCard.Layout+ContainerStyle]
        $Style,

        [PS.AdaptiveCard.Layout+VerticalAlignment]
        $VerticalAlign,

        [switch]
        $Bleed,

        [hashtable]
        $BackgroundImage,

        [int]
        $MinHeight,

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator,

        [PS.AdaptiveCard.Layout+Height]
        $Height
    )

    $ret = @{
        type  = "Container"
        items = $Items
    }

    if ($Id) { $ret.id = $Id }
    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($VerticalAlign) { $ret.verticalContentAlignment = $VerticalAlign.ToString().ToLower() }
    if ($Bleed.IsPresent) { $ret.bleed = $true }
    if ($BackgroundImage) { $ret.backgroundImage = $BackgroundImage }
    if ($MinHeight) { $ret.minHeight = "$($MinHeight)px" }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }
    if ($Height) { $ret.height = $Height.ToString().ToLower() }

    $ret
}
