#Get public and private function definition files
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
foreach($import in @($Public + $Private)) {
    Try {
        Write-Verbose "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}

# Export only Get-MCPTools function
Export-ModuleMember -Function 'Get-MCPTools'
