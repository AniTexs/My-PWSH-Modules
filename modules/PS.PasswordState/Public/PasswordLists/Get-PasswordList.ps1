function Get-PasswordList {
    param (
        [Parameter()]
        [Int]
        $PasswordListID = $null
    )
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    #'https://passwordstate/api/passwordlists/'
    $Path = "/passwordlists"
    if ($PasswordListID) {
        $Path += "/$PasswordListID"
    }
    $resp = Invoke-PWSTRequest -Method Get -Path $Path
    return $resp
}