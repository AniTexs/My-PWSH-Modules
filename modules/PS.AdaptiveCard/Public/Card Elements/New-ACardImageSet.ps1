function New-ACardImageSet {
    <#
    .SYNOPSIS
    Creates an Adaptive Card ImageSet element.

    .DESCRIPTION
    Creates a set of images displayed together with consistent sizing.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Images
    Array of Image objects (created with New-ACardImage). Required.

    .PARAMETER ImageSize
    The size to display all images in the set.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When true, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardImageSet -Images @(
        New-ACardImage -Url "https://example.com/image1.png" -AltText "Image 1"
        New-ACardImage -Url "https://example.com/image2.png" -AltText "Image 2"
    ) -ImageSize Medium
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Images,

        [ValidateSet("Auto", "Stretch", "Small", "Medium", "Large")]
        [string]
        $ImageSize = "Medium",

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator
    )

    $ret = @{
        type      = "ImageSet"
        images    = $Images
        imageSize = $ImageSize.ToLower()
    }

    if ($Id) { $ret.id = $Id }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
