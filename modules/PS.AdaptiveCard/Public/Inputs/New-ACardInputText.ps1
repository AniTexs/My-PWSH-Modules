function New-ACardInputText {
    <#
    .SYNOPSIS
    Creates an Input.Text input field.

    .DESCRIPTION
    Creates a text input field for gathering user input.

    .PARAMETER Id
    A unique identifier for the input field. Required.

    .PARAMETER Label
    Label to display for the input field.

    .PARAMETER Placeholder
    Placeholder text to display when the field is empty.

    .PARAMETER Value
    Default value for the input field.

    .PARAMETER IsMultiline
    When specified, allows multiple lines of text input.

    .PARAMETER MaxLength
    Maximum number of characters allowed.

    .PARAMETER Style
    Input style (text, tel, url, email, password).

    .PARAMETER IsRequired
    When specified, marks the field as required.

    .PARAMETER ErrorMessage
    Error message to display if validation fails.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When specified, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardInputText -Id "name" -Label "Full Name" -Placeholder "Enter your name" -IsRequired
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

        [switch]
        $IsMultiline,

        [int]
        $MaxLength,

        [ValidateSet("text", "tel", "url", "email", "password")]
        [string]
        $Style = "text",

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
        type  = "Input.Text"
        id    = $Id
        style = $Style
    }

    if ($Label) { $ret.label = $Label }
    if ($Placeholder) { $ret.placeholder = $Placeholder }
    if ($Value) { $ret.value = $Value }
    if ($IsMultiline.IsPresent) { $ret.isMultiline = $true }
    if ($MaxLength) { $ret.maxLength = $MaxLength }
    if ($IsRequired.IsPresent) { $ret.isRequired = $true }
    if ($ErrorMessage) { $ret.errorMessage = $ErrorMessage }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
