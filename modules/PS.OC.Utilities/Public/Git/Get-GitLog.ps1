function Get-GitLog {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $NumberOfCommits = 50
    )
    $GitLog = Invoke-Command -ScriptBlock {git log -n $NumberOfCommits}
    if($null -ne $GitLog){
        $GitLog | Convert-GitLog
    }
}