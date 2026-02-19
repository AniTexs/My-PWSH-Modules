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
Function New-OCMatchGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [String]$Name,
        [Parameter(Mandatory = $false)]
        [hashtable]$Metadata,
        [MatchCriteria[]] $Criteria
    )
    process {
        $matchGroup = [MatchGroup]::new()
        $matchGroup.Name = $Name
        $matchGroup.Metadata = $Metadata
        if($Criteria) {
            foreach($criterion in $Criteria) {
                $matchGroup.Criteria.Add($criterion)
            }
        }
        return $matchGroup
    }
}