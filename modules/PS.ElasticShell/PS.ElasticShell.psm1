#region: Module State
# Holds the current connection/session settings
$Script:ElasticSession = [ordered]@{
    BaseUri              = $null
    Headers              = @{}          # Authorization, custom headers
    TimeoutSec           = 100
    DefaultIndex         = $null
    SkipCertificateCheck = $false
}
#endregion

#Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
Write-Verbose "Private functions: $($Private.fullname)"
Write-Verbose "Public functions: $($Public.fullname)"
#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        Write-Verbose "Dot sourcing $($import.fullname)"
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}
if ($args -contains "Beta") {
    Write-Verbose "Beta functions are included"
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename
Export-ModuleMember -Function $Beta.Basename