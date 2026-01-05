# Run Tests for PS.Cegid.HR.Administration Module

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('Unit', 'Integration', 'All')]
    [string]$TestType = 'Unit',
    
    [Parameter()]
    [switch]$CodeCoverage,
    
    [Parameter()]
    [string]$OutputPath = '.\TestResults'
)

# Ensure Pester is available
if (-not (Get-Module -Name Pester -ListAvailable)) {
    throw "Pester module is required. Install it with: Install-Module -Name Pester -Force"
}

# Import Pester
Import-Module Pester -MinimumVersion 5.0 -Force

# Set up paths
$ModulePath = Split-Path -Parent $PSScriptRoot
$TestsPath = $PSScriptRoot

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
}

# Configure Pester
$pesterConfig = New-PesterConfiguration

$pesterConfig.Run.Path = $TestsPath
$pesterConfig.Output.Verbosity = 'Detailed'
$pesterConfig.TestResult.Enabled = $true
$pesterConfig.TestResult.OutputPath = Join-Path $OutputPath 'TestResults.xml'
$pesterConfig.TestResult.OutputFormat = 'NUnitXml'

# Set tags based on test type
switch ($TestType) {
    'Unit' {
        $pesterConfig.Filter.ExcludeTag = 'Integration'
        Write-Host "Running Unit Tests only..." -ForegroundColor Cyan
    }
    'Integration' {
        $pesterConfig.Filter.Tag = 'Integration'
        Write-Host "Running Integration Tests..." -ForegroundColor Cyan
        Write-Host "Ensure TS_BASE_URI, TS_CLIENT_ID, and TS_CLIENT_SECRET environment variables are set." -ForegroundColor Yellow
    }
    'All' {
        Write-Host "Running All Tests..." -ForegroundColor Cyan
    }
}

# Code coverage configuration
if ($CodeCoverage) {
    $pesterConfig.CodeCoverage.Enabled = $true
    $pesterConfig.CodeCoverage.Path = @(
        "$ModulePath\*.psm1",
        "$ModulePath\Private\*.ps1",
        "$ModulePath\Public\*.ps1",
        "$ModulePath\Public\**\*.ps1"
    )
    $pesterConfig.CodeCoverage.OutputPath = Join-Path $OutputPath 'Coverage.xml'
    $pesterConfig.CodeCoverage.OutputFormat = 'JaCoCo'
    Write-Host "Code Coverage enabled" -ForegroundColor Cyan
}

# Run tests
Write-Host "`nExecuting Pester Tests..." -ForegroundColor Green
$results = Invoke-Pester -Configuration $pesterConfig

# Display results
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Test Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total Tests:  $($results.TotalCount)" -ForegroundColor White
Write-Host "Passed:       $($results.PassedCount)" -ForegroundColor Green
Write-Host "Failed:       $($results.FailedCount)" -ForegroundColor $(if ($results.FailedCount -gt 0) { 'Red' } else { 'Green' })
Write-Host "Skipped:      $($results.SkippedCount)" -ForegroundColor Yellow
Write-Host "Duration:     $($results.Duration)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

# Code coverage summary
if ($CodeCoverage -and $results.CodeCoverage) {
    Write-Host "`nCode Coverage Summary:" -ForegroundColor Cyan
    Write-Host "Commands Analyzed: $($results.CodeCoverage.CommandsAnalyzedCount)" -ForegroundColor White
    Write-Host "Commands Executed: $($results.CodeCoverage.CommandsExecutedCount)" -ForegroundColor White
    Write-Host "Commands Missed:   $($results.CodeCoverage.CommandsMissedCount)" -ForegroundColor White
    
    $coveragePercent = [math]::Round(($results.CodeCoverage.CommandsExecutedCount / $results.CodeCoverage.CommandsAnalyzedCount) * 100, 2)
    Write-Host "Coverage:          $coveragePercent%" -ForegroundColor $(if ($coveragePercent -ge 80) { 'Green' } elseif ($coveragePercent -ge 60) { 'Yellow' } else { 'Red' })
}

# Exit with appropriate code
if ($results.FailedCount -gt 0) {
    Write-Host "`nTests FAILED!" -ForegroundColor Red
    exit 1
}
else {
    Write-Host "`nAll tests PASSED!" -ForegroundColor Green
    exit 0
}
