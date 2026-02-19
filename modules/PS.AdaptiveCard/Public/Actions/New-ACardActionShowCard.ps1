function New-ACardActionShowCard {
    <#
    .SYNOPSIS
    Creates an Action.ShowCard action.

    .DESCRIPTION
    Creates an action that shows a card inline when invoked.

    .PARAMETER Title
    Label for the action button. Required.

    .PARAMETER Card
    The adaptive card to display (hashtable representing the card body). Required.

    .PARAMETER Style
    Visual style for the action button.

    .PARAMETER Mode
    Display mode for the action (Primary or Secondary).

    .PARAMETER IconUrl
    Optional icon to display on the button.

    .PARAMETER Tooltip
    Tooltip text to display on hover.

    .EXAMPLE
    New-ACardActionShowCard -Title "Show Details" -Card @(
        New-ACardTextBlock -Text "Additional details here"
    )
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [object]
        $Card,

        [PS.AdaptiveCard.Button+Styles]
        $Style,

        [PS.AdaptiveCard.Button+Mode]
        $Mode,

        [string]
        $IconUrl,

        [string]
        $Tooltip
    )

    $ret = @{
        type  = "Action.ShowCard"
        title = $Title
        card  = @{
            type = "AdaptiveCard"
            body = $Card
        }
    }

    if ($Style) { $ret.style = $Style.ToString().ToLower() }
    if ($Mode) { $ret.mode = $Mode.ToString().ToLower() }

    if ($IconUrl) { $ret.iconUrl = $IconUrl }
    if ($Tooltip) { $ret.tooltip = $Tooltip }

    $ret
}
