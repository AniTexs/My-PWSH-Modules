function New-ACardActionExecute {
    <#
    .SYNOPSIS
    Creates an Action.Execute action.

    .DESCRIPTION
    Creates an action that executes a verb with optional data payload.

    .PARAMETER Title
    Label for the action button. Required.

    .PARAMETER Verb
    The verb to execute.

    .PARAMETER Data
    Optional data payload to send with the execute action.

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
    New-ACardActionExecute -Title "Approve" -Verb "approve" -Data @{requestId = "12345"}
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [string]
        $Verb,

        [hashtable]
        $Data,

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
        type  = "Action.Execute"
        title = $Title
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($Mode) { $ret.mode = $Mode.ToString().ToLower() }
    if ($Verb) { $ret.verb = $Verb }
    if ($Data) { $ret.data = $Data }
    if ($IconUrl) { $ret.iconUrl = $IconUrl }
    if ($Tooltip) { $ret.tooltip = $Tooltip }
    if ($Disabled.IsPresent) { $ret.isEnabled = $false }

    $ret
}
