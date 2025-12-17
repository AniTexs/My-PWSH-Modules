<#
.SYNOPSIS
    Runs all tests for all PowerShell modules.

.DESCRIPTION
    This script discovers and runs tests for all modules in the repository.

.PARAMETER OutputDirectory
    Optional path to output test results. Defaults to './TestResults'.

.EXAMPLE
    .\Test-All.ps1

.EXAMPLE
    .\Test-All.ps1 -OutputDirectory ./TestOutput

.NOTES
    Author: Repository Maintainer
    License: MIT
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$OutputDirectory = './TestResults'
)

$ErrorActionPreference = 'Stop'

Write-Host "Running all module tests..." -ForegroundColor Cyan

# Check if Pester is available
if (-not (Get-Module -ListAvailable -Name Pester)) {
    Write-Host "Pester is not installed. Installing..." -ForegroundColor Yellow
    Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
}

Import-Module Pester -MinimumVersion 5.0 -ErrorAction Stop

$modulesPath = Join-Path $PSScriptRoot ".." "modules"
$moduleDirectories = Get-ChildItem -Path $modulesPath -Directory -ErrorAction SilentlyContinue

if (-not $moduleDirectories) {
    Write-Host "⚠ No modules found in: $modulesPath" -ForegroundColor Yellow
    exit 0
}

# Create output directory
if ($OutputDirectory -and -not (Test-Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$allResults = @()
$failedModules = @()

foreach ($moduleDir in $moduleDirectories) {
    $moduleName = $moduleDir.Name
    $testPath = Join-Path $moduleDir.FullName "Tests"
    
    if (-not (Test-Path $testPath)) {
        Write-Host "`n⚠ No tests found for module: $moduleName" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "`nTesting module: $moduleName" -ForegroundColor Cyan
    
    $config = New-PesterConfiguration
    $config.Run.Path = $testPath
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'Detailed'
    
    if ($OutputDirectory) {
        $outputFile = Join-Path $OutputDirectory "$moduleName-TestResults.xml"
        $config.TestResult.Enabled = $true
        $config.TestResult.OutputPath = $outputFile
        $config.TestResult.OutputFormat = 'NUnitXml'
    }
    
    try {
        $result = Invoke-Pester -Configuration $config
        $allResults += $result
        
        if ($result.FailedCount -gt 0) {
            $failedModules += $moduleName
        }
    }
    catch {
        Write-Host "  ✗ Error running tests: $_" -ForegroundColor Red
        $failedModules += $moduleName
    }
}

# Summary
Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

$totalPassed = ($allResults | Measure-Object -Property PassedCount -Sum).Sum
$totalFailed = ($allResults | Measure-Object -Property FailedCount -Sum).Sum
$totalSkipped = ($allResults | Measure-Object -Property SkippedCount -Sum).Sum
$totalTests = ($allResults | Measure-Object -Property TotalCount -Sum).Sum

Write-Host "Modules tested: $($allResults.Count)" -ForegroundColor Gray
Write-Host "Total tests: $totalTests" -ForegroundColor Gray
Write-Host "Passed: $totalPassed" -ForegroundColor Green
Write-Host "Failed: $totalFailed" -ForegroundColor $(if ($totalFailed -eq 0) { 'Green' } else { 'Red' })
Write-Host "Skipped: $totalSkipped" -ForegroundColor Yellow

if ($failedModules.Count -gt 0) {
    Write-Host "`nFailed modules:" -ForegroundColor Red
    foreach ($module in $failedModules) {
        Write-Host "  - $module" -ForegroundColor Red
    }
    throw "Tests failed in $($failedModules.Count) module(s)"
}

Write-Host "`n✓ All tests passed!" -ForegroundColor Green
