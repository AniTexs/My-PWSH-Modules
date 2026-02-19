function New-ACardInputNumber {
    <#
    .SYNOPSIS
    Creates an Input.Number input field.

    .DESCRIPTION
    Creates a number input field for gathering numeric input.

    .PARAMETER Id
    A unique identifier for the input field. Required.

    .PARAMETER Label
    Label to display for the input field.

    .PARAMETER Placeholder
    Placeholder text to display when the field is empty.

    .PARAMETER Value
    Default value for the input field.

    .PARAMETER Min
    Minimum allowed value.

    .PARAMETER Max
    Maximum allowed value.

    .PARAMETER IsRequired
    When specified, marks the field as required.

    .PARAMETER ErrorMessage
    Error message to display if validation fails.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardInputNumber -Id "age" -Label "Age" -Min 0 -Max 120 -IsRequired
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Id,

        [string]
        $Label,

        [string]
        $Placeholder,

        [double]
        $Value,

        [double]
        $Min,

        [double]
        $Max,

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
        type = "Input.Number"
        id   = $Id
    }

    if ($Label) { $ret.label = $Label }
    if ($Placeholder) { $ret.placeholder = $Placeholder }
    if ($PSBoundParameters.ContainsKey('Value')) { $ret.value = $Value }
    if ($PSBoundParameters.ContainsKey('Min')) { $ret.min = $Min }
    if ($PSBoundParameters.ContainsKey('Max')) { $ret.max = $Max }
    if ($IsRequired.IsPresent) { $ret.isRequired = $true }
    if ($ErrorMessage) { $ret.errorMessage = $ErrorMessage }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
