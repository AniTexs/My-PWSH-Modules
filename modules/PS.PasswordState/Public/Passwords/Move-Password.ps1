function Move-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]
        $PasswordId,
        [Parameter(Mandatory)]
        [Int]
        $DestinationPasswordListID
    )

    $Path = "/passwords/move"
    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    $Data = @{
        PasswordId                = $PasswordId
        DestinationPasswordListID = $DestinationPasswordListID
    }

    try {
        $resp = Invoke-PWSTRequest -Method Put -Path $Path -Body $Data -ErrorAction Stop
        return $resp
    }
    catch {
        throw "Failed to move password: $($_.Exception.Message)"
    }
}