function New-ACardActionOpenUrl {
    <#
    .SYNOPSIS
    Creates an Action.OpenUrl action.

    .DESCRIPTION
    Creates an action that opens a URL when invoked.

    .PARAMETER Title
    Label for the action button. Required.

    .PARAMETER Url
    The URL to open. Required.

    .PARAMETER Style
    Visual style for the action button.

    .PARAMETER Mode
    Display mode for the action (Primary or Secondary).

    .PARAMETER IconUrl
    Optional icon to display on the button.

    .PARAMETER Tooltip
    Tooltip text to display on hover.

    .PARAMETER Disabled
    When specified, the action is disabled.

    .EXAMPLE
    New-ACardActionOpenUrl -Title "Visit Website" -Url "https://example.com"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [string]
        $Url,

        [PS.AdaptiveCard.Button+Styles]
        $Style,

        [PS.AdaptiveCard.Button+Mode]
        $Mode,

        [string]
        $IconUrl,

        [string]
        $Tooltip,

        [switch]
        $Disabled
    )

    $ret = @{
        type  = "Action.OpenUrl"
        title = $Title
        url   = $Url
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($Mode) { $ret.mode = $Mode.ToString().ToLower() }
    if ($IconUrl) { $ret.iconUrl = $IconUrl }
    if ($Tooltip) { $ret.tooltip = $Tooltip }
    if ($Disabled.IsPresent) { $ret.isEnabled = $false }

    $ret
}
