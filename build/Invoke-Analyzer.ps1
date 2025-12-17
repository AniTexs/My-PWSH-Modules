<#
.SYNOPSIS
    Runs PSScriptAnalyzer on PowerShell modules.

.DESCRIPTION
    This script runs PSScriptAnalyzer on all modules or a specific module
    to ensure code quality and adherence to best practices.

.PARAMETER ModuleName
    Optional. The name of a specific module to analyze. If not provided, all modules are analyzed.

.PARAMETER Severity
    The minimum severity level to report. Defaults to 'Warning'.

.EXAMPLE
    .\Invoke-Analyzer.ps1

.EXAMPLE
    .\Invoke-Analyzer.ps1 -ModuleName MyModule -Severity Error

.NOTES
    Author: Repository Maintainer
    License: MIT
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$ModuleName,

    [Parameter()]
    [ValidateSet('Error', 'Warning', 'Information')]
    [string]$Severity = 'Warning'
)

$ErrorActionPreference = 'Stop'

Write-Host "Running PSScriptAnalyzer..." -ForegroundColor Cyan

# Check if PSScriptAnalyzer is available
if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Host "PSScriptAnalyzer is not installed. Installing..." -ForegroundColor Yellow
    Install-Module -Name PSScriptAnalyzer -Force -SkipPublisherCheck -Scope CurrentUser
}

Import-Module PSScriptAnalyzer -ErrorAction Stop

$modulesPath = Join-Path $PSScriptRoot ".." "modules"

if ($ModuleName) {
    # Analyze specific module
    $targetPath = Join-Path $modulesPath $ModuleName
    if (-not (Test-Path $targetPath)) {
        throw "Module '$ModuleName' not found at path: $targetPath"
    }
    Write-Host "Analyzing module: $ModuleName" -ForegroundColor Cyan
    $paths = @($targetPath)
}
else {
    # Analyze all modules
    Write-Host "Analyzing all modules..." -ForegroundColor Cyan
    $paths = Get-ChildItem -Path $modulesPath -Directory | Select-Object -ExpandProperty FullName
    
    if ($paths.Count -eq 0) {
        Write-Host "⚠ No modules found in: $modulesPath" -ForegroundColor Yellow
        exit 0
    }
}

$allResults = @()
$hasErrors = $false

foreach ($path in $paths) {
    $moduleName = Split-Path $path -Leaf
    Write-Host "`nAnalyzing: $moduleName" -ForegroundColor Gray
    
    $results = Invoke-ScriptAnalyzer -Path $path -Recurse -Severity $Severity
    
    if ($results) {
        $allResults += $results
        
        foreach ($result in $results) {
            $color = switch ($result.Severity) {
                'Error' { 'Red' }
                'Warning' { 'Yellow' }
                default { 'Gray' }
            }
            
            Write-Host "  [$($result.Severity)] $($result.RuleName)" -ForegroundColor $color
            Write-Host "    $($result.Message)" -ForegroundColor Gray
            Write-Host "    at $($result.ScriptName):$($result.Line)" -ForegroundColor Gray
        }
        
        if ($results | Where-Object { $_.Severity -eq 'Error' }) {
            $hasErrors = $true
        }
    }
    else {
        Write-Host "  ✓ No issues found" -ForegroundColor Green
    }
}

# Summary
Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
Write-Host "Analysis Summary" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

if ($allResults.Count -eq 0) {
    Write-Host "✓ No issues found!" -ForegroundColor Green
}
else {
    $errorCount = ($allResults | Where-Object { $_.Severity -eq 'Error' }).Count
    $warningCount = ($allResults | Where-Object { $_.Severity -eq 'Warning' }).Count
    $infoCount = ($allResults | Where-Object { $_.Severity -eq 'Information' }).Count
    
    Write-Host "Errors: $errorCount" -ForegroundColor $(if ($errorCount -eq 0) { 'Green' } else { 'Red' })
    Write-Host "Warnings: $warningCount" -ForegroundColor $(if ($warningCount -eq 0) { 'Green' } else { 'Yellow' })
    Write-Host "Information: $infoCount" -ForegroundColor Gray
    
    if ($hasErrors) {
        throw "PSScriptAnalyzer found $errorCount error(s)"
    }
}

Write-Host "`n✓ Analysis completed successfully!" -ForegroundColor Green
