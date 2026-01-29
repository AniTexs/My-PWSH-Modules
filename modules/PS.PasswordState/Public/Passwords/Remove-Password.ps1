function Remove-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0,ValueFromPipelineByPropertyName=$true)]
        [int]$PasswordID,
        [Switch]$MovetoRecycleBin
    )

    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    if(-not (Get-Password -PasswordID $PasswordID)){
        throw "No password found with ID $PasswordID"
    }

    $Body = @{
        MoveToRecycleBin = $MoveToRecycleBin.IsPresent ? $MoveToRecycleBin : $false
    }

    $Path = "/passwords/$PasswordID"
    $resp = Invoke-PWSTRequest -Method Delete -Path $Path -Query $Body
    return $resp
}