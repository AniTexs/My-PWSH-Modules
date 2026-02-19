function New-ACardFact {
    <#
    .SYNOPSIS
    Creates a Fact for use in FactSet elements.

    .DESCRIPTION
    Creates a fact with a title and value for display in a FactSet.

    .PARAMETER Title
    The title/label for the fact. Required.

    .PARAMETER Value
    The value of the fact. Required.

    .EXAMPLE
    New-ACardFact -Title "Name" -Value "John Doe"
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
