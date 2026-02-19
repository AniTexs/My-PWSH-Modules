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
function Find-OCMatch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,ValueFromPipeline = $true)]
        [psobject] $InputObject,
        [Parameter(Mandatory = $true)]
        [MatchGroup[]] $MatchGroups
    )
    process {
        foreach ($matchGroup in $MatchGroups) {
            $isMatch = $true
            foreach ($criteria in $matchGroup.Criteria) {
                if (-not (& $criteria.CriteriaScript $InputObject)) {
                    $isMatch = $false
                    break
                }
            }
            if ($isMatch) {
                Write-Output $matchGroup
            }
        }
    }
    
}