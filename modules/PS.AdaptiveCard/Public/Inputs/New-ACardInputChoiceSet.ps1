function New-ACardInputChoiceSet {
    <#
    .SYNOPSIS
    Creates an Input.ChoiceSet input field.

    .DESCRIPTION
    Creates a choice set (dropdown or radio buttons) for selecting options.

    .PARAMETER Id
    A unique identifier for the input field. Required.

    .PARAMETER Choices
    Array of choices (created with New-ACardInputChoice). Required.

    .PARAMETER Label
    Label to display for the input field.

    .PARAMETER Value
    Default selected value (or comma-separated values for multi-select).

    .PARAMETER Placeholder
    Placeholder text to display when no selection is made.

    .PARAMETER IsMultiSelect
    When specified, allows multiple selections.

    .PARAMETER Style
    Display style (compact for dropdown, expanded for radio buttons).

    .PARAMETER IsRequired
    When specified, marks the field as required.

    .PARAMETER ErrorMessage
    Error message to display if validation fails.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardInputChoiceSet -Id "country" -Label "Country" -Choices @(
        New-ACardInputChoice -Title "USA" -Value "us"
        New-ACardInputChoice -Title "Canada" -Value "ca"
    ) -Style compact -IsRequired
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Choices,

        [string]
        $Label,

        [string]
        $Value,

        [string]
        $Placeholder,

        [switch]
        $IsMultiSelect,

        [ValidateSet("compact", "expanded", "filtered")]
        [string]
        $Style = "compact",

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
        type    = "Input.ChoiceSet"
        id      = $Id
        choices = $Choices
        style   = $Style
    }

    if ($Label) { $ret.label = $Label }
    if ($Value) { $ret.value = $Value }
    if ($Placeholder) { $ret.placeholder = $Placeholder }
    if ($IsMultiSelect.IsPresent) { $ret.isMultiSelect = $true }
    if ($IsRequired.IsPresent) { $ret.isRequired = $true }
    if ($ErrorMessage) { $ret.errorMessage = $ErrorMessage }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
