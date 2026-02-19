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