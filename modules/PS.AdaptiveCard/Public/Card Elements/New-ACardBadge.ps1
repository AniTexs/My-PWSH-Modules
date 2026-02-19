function New-ACardBadge {
    <#
    .SYNOPSIS
    Creates an Adaptive Card Badge element.

    .DESCRIPTION
    Creates a badge with text, style, and shape options.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Text
    The text to display in the badge. Required.

    .PARAMETER Size
    The size of the badge (Medium, Large, ExtraLarge).

    .PARAMETER Style
    The visual style of the badge.

    .PARAMETER Shape
    The shape of the badge (Default, Circular, Rounded).

    .EXAMPLE
    New-ACardBadge -Text "Active" -Style Good -Shape Circular
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [String]
        $Text,
        
        [Parameter()]
        [ValidateSet("Medium", "Large", "ExtraLarge")]
        [String]
        $Size = "Large",
        
        [PS.AdaptiveCard.Badge+Styles]
        $Style,
        
        [PS.AdaptiveCard.Badge+Shape]
        $Shape = "Circular"
    )
    
    $ret = @{
        type  = "Badge"
        text  = $Text
        size  = $Size
        shape = $Shape.ToString()
        style = $Style.ToString()
    }
    
    if ($Id) { $ret.id = $Id }
    
    $ret
}