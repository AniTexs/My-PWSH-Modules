function New-ACardActionSubmit {
    <#
    .SYNOPSIS
    Creates an Action.Submit action.

    .DESCRIPTION
    Creates an action that gathers input fields and submits them to the host.

    .PARAMETER Title
    Label for the action button. Required.

    .PARAMETER Data
    Optional data to include with the submission.

    .PARAMETER AssociatedInputs
    Controls which inputs are associated with the submit action ("auto" or "none").

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
    New-ACardActionSubmit -Title "Submit" -Data @{action = "submit"; type = "form"}
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [hashtable]
        $Data,

        [ValidateSet("auto", "none")]
        [string]
        $AssociatedInputs = "auto",

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
        type             = "Action.Submit"
        title            = $Title
        associatedInputs = $AssociatedInputs
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($Mode) { $ret.mode = $Mode.ToString().ToLower() }
    if ($Data) { $ret.data = $Data }
    if ($IconUrl) { $ret.iconUrl = $IconUrl }
    if ($Tooltip) { $ret.tooltip = $Tooltip }
    if ($Disabled.IsPresent) { $ret.isEnabled = $false }

    $ret
}
