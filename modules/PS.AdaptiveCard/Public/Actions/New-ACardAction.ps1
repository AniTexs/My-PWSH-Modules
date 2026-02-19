function New-ACardAction {
    <#
    .SYNOPSIS
    Creates a generic Adaptive Card action.

    .DESCRIPTION
    Creates an action of the specified type. For more specific action creation with additional properties, use the dedicated functions like New-ACardActionSubmit, New-ACardActionOpenUrl, etc.

    .PARAMETER Type
    The type of action to create. Valid values: Submit, OpenUrl, Execute, ToggleVisibility, ShowCard.

    .PARAMETER Title
    Label for the action button. Required.

    .PARAMETER Tooltip
    Tooltip text to display on hover.

    .PARAMETER Style
    Visual style for the action button.

    .PARAMETER Mode
    Display mode for the action (Primary or Secondary).

    .PARAMETER IconUrl
    Optional icon to display on the button.

    .PARAMETER Disabled
    When specified, the action is disabled.

    .EXAMPLE
    New-ACardAction -Type Submit -Title "Submit Form"

    .EXAMPLE
    New-ACardAction -Type OpenUrl -Title "Learn More" -Style Positive

    .NOTES
    For actions requiring specific properties (like URL for OpenUrl or Data for Submit), use the dedicated functions:
    - New-ACardActionSubmit
    - New-ACardActionOpenUrl
    - New-ACardActionShowCard
    - New-ACardActionToggleVisibility
    - New-ACardActionExecute
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("Submit", "OpenUrl", "Execute", "ToggleVisibility", "ShowCard")]
        [PS.AdaptiveCard.Action+Type]
        $Type = "Submit",
        [Parameter(Mandatory)]
        [string]
        $Title,
        [string]
        $Tooltip,
        [PS.AdaptiveCard.Button+Styles]
        $Style = "Default",
        [PS.AdaptiveCard.Button+Mode]
        $Mode = "Primary",
        [string]
        $IconUrl,
        [Switch]
        $Disabled
    )
    $Action = @{
        type  = "Action.$Type"
        title = $Title
        style = $Style.ToString().ToLower()
        mode  = $Mode.ToString().ToLower()
    }
    if ($Tooltip) { $Action.tooltip = $Tooltip }
    if ($IconUrl) { $Action.iconUrl = $IconUrl }
    if ($Disabled.IsPresent) { $Action.isEnabled = $false }
    $Action
}