#TODO: Add all Properties
function New-ACardColumnSet {
    [CmdletBinding()]
    param (
        [string]
        $Id,
        [Parameter(Mandatory)]
        [hashtable[]]
        $Columns
    )
    $ret = @{
        type    = "ColumnSet"
        columns = $Columns
    }
    if ($Id) { $ret.id = $Id }
    $ret
}