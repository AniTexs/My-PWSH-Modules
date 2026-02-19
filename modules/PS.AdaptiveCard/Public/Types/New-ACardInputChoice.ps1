function New-ACardInputChoice {
    <#
    .SYNOPSIS
    Creates a choice for use in ChoiceSet inputs.

    .DESCRIPTION
    Creates a choice option with a display title and submission value.

    .PARAMETER Title
    Display text for the choice. Required.

    .PARAMETER Value
    Value to submit when this choice is selected. Required.

    .EXAMPLE
    New-ACardInputChoice -Title "United States" -Value "us"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [string]
        $Value
    )

    @{
        title = $Title
        value = $Value
    }
}
