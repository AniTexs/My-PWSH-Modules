function New-ACardCaptionSource {
    <#
    .SYNOPSIS
    Creates a caption source for use with Media elements.

    .DESCRIPTION
    Defines a caption/subtitle source for media playback.

    .PARAMETER Url
    URL to the caption file. Required.

    .PARAMETER MimeType
    MIME type of the caption file (e.g., "text/vtt"). Required.

    .PARAMETER Label
    Label to display for this caption track.

    .EXAMPLE
    New-ACardCaptionSource -Url "https://example.com/captions.vtt" -MimeType "text/vtt" -Label "English"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Url,

        [Parameter(Mandatory)]
        [string]
        $MimeType,

        [string]
        $Label
    )

    $ret = @{
        url      = $Url
        mimeType = $MimeType
    }

    if ($Label) { $ret.label = $Label }

    $ret
}
