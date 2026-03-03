function Add-DocumentToPassword {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int]$PasswordId,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File,
        
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [String]$Description
    )
    $Path = "/document/password/$PasswordId"
    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    # Validate the password Exists
    try {
        $password = Get-Password -PasswordId $PasswordId -ErrorAction Stop
        if(-not $password) {
            throw "Password with ID $PasswordId does not exist"
        }
    }
    catch {
        throw "Unable to retrieve password with ID $PasswordId"
    }

    # Validate the file is correct
    if (-not $File.Exists) {
        throw "The specified file does not exist: $($File.FullName)"
    }
    $Query = @{
        DocumentName = [uri]::EscapeDataString($Name)
        DocumentDescription = [uri]::EscapeDataString($Description)
    }

    try {
        $resp = Invoke-PWSTRequest -Method Post -Path $Path -File $File -Query $Query -ErrorAction Stop
        return $resp
    }
    catch {
        throw "Failed to create new document for password ID $PasswordId : $($_.Exception.Message)"
    }
}