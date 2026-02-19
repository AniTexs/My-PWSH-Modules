class MatchCriteria {
    [ScriptBlock] $CriteriaScript
    MatchCriteria ([ScriptBlock] $script) {
        $this.CriteriaScript = $script
    }
}
class MatchGroup {
    [System.Collections.Generic.List[MatchCriteria]] $Criteria = [System.Collections.Generic.List[MatchCriteria]]::new()
    [String] $Name
    [String] $Description
    [hashtable] $Metadata = @{}
}
function New-OCMatchCriteria {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ScriptBlock]$Criteria,
        [Parameter(Mandatory = $false,ValueFromPipeline = $true)]
        [MatchGroup]$InputObject
    )

    process {
        $matchCriteria = [MatchCriteria]::new($Criteria)
        if ($InputObject) {
            $InputObject.Criteria.Add($matchCriteria)
            return $InputObject
        } else {
            return $matchCriteria
        }
    }
}