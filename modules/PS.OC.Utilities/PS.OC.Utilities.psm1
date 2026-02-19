#Load classes first
$Classes = @( Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue )
Foreach($import in $Classes)
{
    Try
    {
        Write-Verbose "Importing class $($import.fullname)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import class $($import.fullname): $_"
    }
}

#Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Define Windows-specific functions that should only be loaded on Windows
$WindowsOnlyFunctions = @(
    'Get-LocalPasswordPolicy.ps1'
    'Test-LocalPasswordComplexity.ps1'
)

# Determine if running on Windows (handles both PS 5.1 and PS Core)
# In PowerShell 5.1, $IsWindows is not defined, but we're always on Windows
$isWindowsOS = if ($null -eq (Get-Variable -Name 'IsWindows' -ErrorAction SilentlyContinue)) {
    $true  # PowerShell 5.1 - always Windows
} else {
    $IsWindows  # PowerShell Core - use the automatic variable
}

# Filter out Windows-specific functions if not running on Windows
if (-not $isWindowsOS) {
    Write-Verbose "Non-Windows OS detected. Excluding Windows-specific functions."
    $Public = $Public | Where-Object { $WindowsOnlyFunctions -notcontains $_.Name }
}

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        Write-Verbose "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
