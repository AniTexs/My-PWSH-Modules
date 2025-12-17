<#
.SYNOPSIS
    Runs tests for a PowerShell module.

.DESCRIPTION
    This script runs Pester tests for a specified PowerShell module.

.PARAMETER ModuleName
    The name of the module to test.

.PARAMETER OutputFile
    Optional path to output test results in NUnitXml format.

.EXAMPLE
    .\Test-Module.ps1 -ModuleName MyModule

.EXAMPLE
    .\Test-Module.ps1 -ModuleName MyModule -OutputFile ./TestResults.xml

.NOTES
    Author: Repository Maintainer
    License: MIT
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModuleName,

    [Parameter()]
    [string]$OutputFile
)

$ErrorActionPreference = 'Stop'

Write-Host "Testing module: $ModuleName" -ForegroundColor Cyan

# Check if Pester is available
if (-not (Get-Module -ListAvailable -Name Pester)) {
    Write-Host "Pester is not installed. Installing..." -ForegroundColor Yellow
    Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
}

# Import Pester
Import-Module Pester -MinimumVersion 5.0 -ErrorAction Stop

# Validate module exists
$modulePath = Join-Path $PSScriptRoot ".." "modules" $ModuleName
if (-not (Test-Path $modulePath)) {
    throw "Module '$ModuleName' not found at path: $modulePath"
}

Write-Host "✓ Module found at: $modulePath" -ForegroundColor Green

# Look for test files
$testPath = Join-Path $modulePath "Tests"
if (-not (Test-Path $testPath)) {
    Write-Host "⚠ No tests directory found at: $testPath" -ForegroundColor Yellow
    Write-Host "Creating tests directory structure..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $testPath -Force | Out-Null
    Write-Host "✓ Tests directory created. Please add tests!" -ForegroundColor Green
    exit 0
}

# Run Pester tests
Write-Host "Running tests..." -ForegroundColor Cyan

$config = New-PesterConfiguration
$config.Run.Path = $testPath
$config.Run.PassThru = $true
$config.Output.Verbosity = 'Detailed'

if ($OutputFile) {
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputPath = $OutputFile
    $config.TestResult.OutputFormat = 'NUnitXml'
}

$result = Invoke-Pester -Configuration $config

# Report results
Write-Host "`nTest Results:" -ForegroundColor Cyan
Write-Host "  Passed: $($result.PassedCount)" -ForegroundColor Green
Write-Host "  Failed: $($result.FailedCount)" -ForegroundColor $(if ($result.FailedCount -eq 0) { 'Green' } else { 'Red' })
Write-Host "  Skipped: $($result.SkippedCount)" -ForegroundColor Yellow
Write-Host "  Total: $($result.TotalCount)" -ForegroundColor Gray

if ($result.FailedCount -gt 0) {
    throw "Tests failed with $($result.FailedCount) failure(s)"
}

Write-Host "`n✓ All tests passed!" -ForegroundColor Green
