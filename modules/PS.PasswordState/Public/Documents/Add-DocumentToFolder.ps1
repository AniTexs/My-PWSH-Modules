function Add-DocumentToList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Int]$FolderId,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File,
        
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [String]$Description
    )
    $Path = "/document/folder/$FolderId"
    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    # Validate the file is correct
    if (-not $File.Exists) {
        throw "The specified file does not exist: $($File.FullName)"
    }
    $Query = @{
        DocumentName = $Name
        DocumentDescription = $Description
    }

    try {
        $resp = Invoke-PWSTRequest -Method Post -Path $Path -File $File -Query $Query -ErrorAction Stop
        return $resp
    }
    catch {
        throw "Failed to create new password: $($_.Exception.Message)"
    }
}