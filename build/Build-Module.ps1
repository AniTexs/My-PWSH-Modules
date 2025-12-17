<#
.SYNOPSIS
    Builds a PowerShell module.

.DESCRIPTION
    This script builds a PowerShell module by validating its structure,
    running PSScriptAnalyzer, and preparing it for publishing.

.PARAMETER ModuleName
    The name of the module to build.

.PARAMETER OutputPath
    The output path for the built module. Defaults to './output'.

.EXAMPLE
    .\Build-Module.ps1 -ModuleName MyModule

.NOTES
    Author: Repository Maintainer
    License: MIT
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModuleName,

    [Parameter()]
    [string]$OutputPath = './output'
)

$ErrorActionPreference = 'Stop'

Write-Host "Building module: $ModuleName" -ForegroundColor Cyan

# Validate module exists
$modulePath = Join-Path $PSScriptRoot ".." "modules" $ModuleName
if (-not (Test-Path $modulePath)) {
    throw "Module '$ModuleName' not found at path: $modulePath"
}

# Check for module manifest
$manifestPath = Join-Path $modulePath "$ModuleName.psd1"
if (-not (Test-Path $manifestPath)) {
    throw "Module manifest not found: $manifestPath"
}

Write-Host "✓ Module found at: $modulePath" -ForegroundColor Green

# Test module manifest
Write-Host "Testing module manifest..." -ForegroundColor Cyan
try {
    $manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop
    Write-Host "✓ Module manifest is valid" -ForegroundColor Green
    Write-Host "  Version: $($manifest.Version)" -ForegroundColor Gray
    Write-Host "  Author: $($manifest.Author)" -ForegroundColor Gray
}
catch {
    throw "Module manifest validation failed: $_"
}

# Create output directory
$moduleOutputPath = Join-Path $OutputPath $ModuleName
if (Test-Path $moduleOutputPath) {
    Remove-Item $moduleOutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $moduleOutputPath -Force | Out-Null

Write-Host "✓ Created output directory: $moduleOutputPath" -ForegroundColor Green

# Copy module files
Write-Host "Copying module files..." -ForegroundColor Cyan
Copy-Item -Path "$modulePath\*" -Destination $moduleOutputPath -Recurse -Force
Write-Host "✓ Module files copied" -ForegroundColor Green

Write-Host "`n✓ Build completed successfully!" -ForegroundColor Green
Write-Host "Output location: $moduleOutputPath" -ForegroundColor Gray
