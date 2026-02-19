function New-ACardTargetElement {
    <#
    .SYNOPSIS
    Creates a target element for ToggleVisibility actions.

    .DESCRIPTION
    Defines an element to toggle visibility on.

    .PARAMETER ElementId
    The ID of the element to target. Required.

    .PARAMETER IsVisible
    Whether the element should be visible after the action.

    .EXAMPLE
    New-ACardTargetElement -ElementId "detailsSection" -IsVisible $true
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ElementId,

        [bool]
        $IsVisible
    )

    $ret = @{
        elementId = $ElementId
    }

    if ($PSBoundParameters.ContainsKey('IsVisible')) {
        $ret.isVisible = $IsVisible
    }

    $ret
}
