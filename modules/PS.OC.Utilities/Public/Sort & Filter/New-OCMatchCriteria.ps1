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