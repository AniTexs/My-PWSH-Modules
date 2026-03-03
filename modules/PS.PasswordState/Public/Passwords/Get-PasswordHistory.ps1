function Get-PasswordHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]
        $PasswordId
    )

    $Path = "/passwordhistory/$PasswordId"
    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    try {
        $resp = Invoke-PWSTRequest -Method GET -Path $Path -ErrorAction Stop
        return $resp
    }
    catch {
        throw "Failed to get password history: $($_.Exception.Message)"
    }
}