function New-ACardMedia {
    <#
    .SYNOPSIS
    Creates an Adaptive Card Media element.

    .DESCRIPTION
    Creates a media playback element for audio or video content.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Sources
    Array of media sources (created with New-ACardMediaSource).

    .PARAMETER Poster
    URL to an image to display before the media is played.

    .PARAMETER AltText
    Alternate text for accessibility.

    .PARAMETER CaptionSources
    Array of caption sources (created with New-ACardCaptionSource).

    .EXAMPLE
    New-ACardMedia -Sources @(New-ACardMediaSource -Url "https://example.com/video.mp4" -MimeType "video/mp4") -Poster "https://example.com/poster.jpg"
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Sources,

        [string]
        $Poster,

        [string]
        $AltText,

        [hashtable[]]
        $CaptionSources
    )

    $ret = @{
        type    = "Media"
        sources = $Sources
    }

    if ($Id) { $ret.id = $Id }
    if ($Poster) { $ret.poster = $Poster }
    if ($AltText) { $ret.altText = $AltText }
    if ($CaptionSources) { $ret.captionSources = $CaptionSources }

    $ret
}
