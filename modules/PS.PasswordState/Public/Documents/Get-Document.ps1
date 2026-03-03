function Get-Document {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]    
        [Int]$DocumentId,

        [ValidateSet('Password', 'Folder', 'PasswordList')]
        [Parameter(Mandatory = $false)]
        [string]
        $DocumentLocation
    )

    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    
    if ([String]::IsNullOrWhiteSpace($DocumentLocation)) {
        $StoragePaths = @(
            'password'
            'folder'
            'passwordlist'
        )
    }else{
        $StoragePaths = @(
            $DocumentLocation.ToLower()
        )
    }

    foreach ($StoragePath in $StoragePaths) {
        Write-Verbose "Attempting to retrieve document from $StoragePath"
        $Path = "/document/$StoragePath/$DocumentId"

        try {
            $resp = Invoke-PWSTRequest -Method Get -Path $Path -ErrorAction Stop
            return $resp
        }
        catch {
            Write-Verbose "Failed to retrieve document from $StoragePath : $($_.Exception.Message)"
        }
    }
    throw "Failed to retrieve document: $($_.Exception.Message)"
}