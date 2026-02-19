function New-ACardInputDate {
    <#
    .SYNOPSIS
    Creates an Input.Date input field.

    .DESCRIPTION
    Creates a date picker input field.

    .PARAMETER Id
    A unique identifier for the input field. Required.

    .PARAMETER Label
    Label to display for the input field.

    .PARAMETER Placeholder
    Placeholder text to display when the field is empty.

    .PARAMETER Value
    Default value in ISO 8601 format (YYYY-MM-DD).

    .PARAMETER Min
    Minimum allowed date in ISO 8601 format.

    .PARAMETER Max
    Maximum allowed date in ISO 8601 format.

    .PARAMETER IsRequired
    When specified, marks the field as required.

    .PARAMETER ErrorMessage
    Error message to display if validation fails.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardInputDate -Id "dob" -Label "Date of Birth" -IsRequired
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

        [string]
        $Value,

        [string]
        $Min,

        [string]
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
        type = "Input.Date"
        id   = $Id
    }

    if ($Label) { $ret.label = $Label }
    if ($Placeholder) { $ret.placeholder = $Placeholder }
    if ($Value) { $ret.value = $Value }
    if ($Min) { $ret.min = $Min }
    if ($Max) { $ret.max = $Max }
    if ($IsRequired.IsPresent) { $ret.isRequired = $true }
    if ($ErrorMessage) { $ret.errorMessage = $ErrorMessage }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
