function Copy-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]
        $PasswordId,
        [Parameter(Mandatory)]
        [Int]
        $DestinationPasswordListID,
        [Switch]
        $Link
    )

    $Path = "/passwords/copy"
    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    $Data = @{
        PasswordId                = $PasswordId
        DestinationPasswordListID = $DestinationPasswordListID
        Link                      = $Link.IsPresent
    }

    try {
        $resp = Invoke-PWSTRequest -Method Post -Path $Path -Body $Data -ErrorAction Stop
        return $resp
    }
    catch {
        throw "Failed to move password: $($_.Exception.Message)"
    }
}