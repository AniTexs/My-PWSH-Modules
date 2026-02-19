function New-ACardActionSet {
    <#
    .SYNOPSIS
    Creates an Adaptive Card ActionSet element.

    .DESCRIPTION
    Creates a container for displaying actions together.

    .PARAMETER Id
    A unique identifier for the element.

    .PARAMETER Actions
    Array of actions to display. Required.

    .EXAMPLE
    New-ACardActionSet -Actions @(
        New-ACardActionSubmit -Title "Submit"
        New-ACardActionOpenUrl -Title "Learn More" -Url "https://example.com"
    )
    #>
    [CmdletBinding()]
    param (
        [string]
        $Id,

        [Parameter(Mandatory)]
        [hashtable[]]
        $Actions
    )
    
    $ret = @{
        type    = "ActionSet"
        actions = $Actions
    }
    
    if ($Id) { $ret.id = $Id }
    
    $ret
}