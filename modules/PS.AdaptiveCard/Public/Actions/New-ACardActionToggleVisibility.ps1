function New-ACardActionToggleVisibility {
    <#
    .SYNOPSIS
    Creates an Action.ToggleVisibility action.

    .DESCRIPTION
    Creates an action that toggles the visibility of elements.

    .PARAMETER Title
    Label for the action button. Required.

    .PARAMETER TargetElements
    Array of target elements to toggle (created with New-ACardTargetElement). Required.

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
    New-ACardActionToggleVisibility -Title "Show More" -TargetElements @(
        New-ACardTargetElement -ElementId "details" -IsVisible $true
    )
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [hashtable[]]
        $TargetElements,

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
        type           = "Action.ToggleVisibility"
        title          = $Title
        targetElements = $TargetElements
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($Mode) { $ret.mode = $Mode.ToString().ToLower() }

    if ($IconUrl) { $ret.iconUrl = $IconUrl }
    if ($Tooltip) { $ret.tooltip = $Tooltip }
    if ($Disabled.IsPresent) { $ret.isEnabled = $false }

    $ret
}
