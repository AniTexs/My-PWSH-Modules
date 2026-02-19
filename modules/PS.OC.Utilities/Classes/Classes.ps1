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
