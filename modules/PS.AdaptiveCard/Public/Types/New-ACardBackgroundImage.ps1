function New-ACardBackgroundImage {
    <#
    .SYNOPSIS
    Creates a background image for containers or cards.

    .DESCRIPTION
    Defines a background image with positioning and fill options.

    .PARAMETER Url
    URL to the background image. Required.

    .PARAMETER FillMode
    How the image should fill the space (cover, repeatHorizontally, repeatVertically, repeat).

    .PARAMETER HorizontalAlign
    Horizontal alignment of the background image.

    .PARAMETER VerticalAlign
    Vertical alignment of the background image.

    .EXAMPLE
    New-ACardBackgroundImage -Url "https://example.com/bg.jpg" -FillMode cover
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Url,

        [ValidateSet("cover", "repeatHorizontally", "repeatVertically", "repeat")]
        [string]
        $FillMode = "cover",

        [ValidateSet("left", "center", "right")]
        [string]
        $HorizontalAlign = "center",

        [ValidateSet("top", "center", "bottom")]
        [string]
        $VerticalAlign = "center"
    )

    @{
        url                 = $Url
        fillMode            = $FillMode
        horizontalAlignment = $HorizontalAlign
        verticalAlignment   = $VerticalAlign
    }
}
