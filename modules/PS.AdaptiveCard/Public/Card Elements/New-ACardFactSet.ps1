function New-ACardFactSet {
    <#
    .SYNOPSIS
    Creates an Adaptive Card FactSet element.

    .DESCRIPTION
    Creates a set of facts displayed in a two-column layout (title and value).

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Facts
    Array of Fact objects (created with New-ACardFact). Required.

    .PARAMETER Spacing
    Controls spacing before the element.

    .PARAMETER Separator
    When true, draw a separating line at the top of the element.

    .EXAMPLE
    New-ACardFactSet -Facts @(
        New-ACardFact -Title "Name" -Value "John Doe"
        New-ACardFact -Title "Email" -Value "john@example.com"
    )
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Facts,

        [PS.AdaptiveCard.Layout+Spacing]
        $Spacing,

        [switch]
        $Separator
    )

    $ret = @{
        type  = "FactSet"
        facts = $Facts
    }

    if ($Id) { $ret.id = $Id }
    if ($Spacing) { $ret.spacing = $Spacing.ToString().ToLower() }
    if ($Separator.IsPresent) { $ret.separator = $true }

    $ret
}
