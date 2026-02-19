function New-ACardMediaSource {
    <#
    .SYNOPSIS
    Creates a media source for use with Media elements.

    .DESCRIPTION
    Defines a media source with URL and MIME type.

    .PARAMETER Url
    URL to the media file. Required.

    .PARAMETER MimeType
    MIME type of the media (e.g., "video/mp4", "audio/mp3"). Required.

    .EXAMPLE
    New-ACardMediaSource -Url "https://example.com/video.mp4" -MimeType "video/mp4"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Url,

        [Parameter(Mandatory)]
        [string]
        $MimeType
    )

    @{
        url      = $Url
        mimeType = $MimeType
    }
}
