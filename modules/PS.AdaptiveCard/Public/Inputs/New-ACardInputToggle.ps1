function New-ACardInputToggle {
    <#
    .SYNOPSIS
    Creates an Input.Toggle input field.

    .DESCRIPTION
    Creates a toggle/checkbox input field.

    .PARAMETER Id
    A unique identifier for the input field. Required.

    .PARAMETER Title
    Title text to display next to the toggle. Required.

    .PARAMETER Label
    Label to display for the input field.

    .PARAMETER Value
    Default value for the toggle.

    .PARAMETER ValueOn
    Value to submit when toggle is on. Default is "true".

    .PARAMETER ValueOff
    Value to submit when toggle is off. Default is "false".

    .PARAMETER Wrap
    When specified, allows the title text to wrap.

    .PARAMETER IsRequired
    When specified, marks the field as required.

    .PARAMETER ErrorMessage
    Error message to display if validation fails.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardInputToggle -Id "agree" -Title "I agree to the terms" -IsRequired
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Id,

        [Parameter(Mandatory)]
        [string]
        $Title,

        [string]
        $Label,

        [string]
        $Value,

        [string]
        $ValueOn = "true",

        [string]
        $ValueOff = "false",

        [switch]
        $Wrap,

        [switch]
        $IsRequired,

        [string]
        $ErrorMessage,

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator
    )

    $ret = @{
        type     = "Input.Toggle"
        id       = $Id
        title    = $Title
        valueOn  = $ValueOn
        valueOff = $ValueOff
    }

    if ($Label) { $ret.label = $Label }
    if ($Value) { $ret.value = $Value }
    if ($Wrap.IsPresent) { $ret.wrap = $true }
    if ($IsRequired.IsPresent) { $ret.isRequired = $true }
    if ($ErrorMessage) { $ret.errorMessage = $ErrorMessage }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
