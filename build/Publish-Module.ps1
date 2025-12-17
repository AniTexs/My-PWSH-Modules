<#
.SYNOPSIS
    Publishes a PowerShell module to PSGallery.

.DESCRIPTION
    This script publishes a PowerShell module to the PowerShell Gallery.
    Requires a PSGallery API key to be provided.

.PARAMETER ModuleName
    The name of the module to publish.

.PARAMETER ApiKey
    The PSGallery API key for authentication.

.PARAMETER Repository
    The repository to publish to. Defaults to 'PSGallery'.

.PARAMETER WhatIf
    If specified, shows what would be published without actually publishing.

.EXAMPLE
    .\Publish-Module.ps1 -ModuleName MyModule -ApiKey $env:PSGALLERY_API_KEY

.EXAMPLE
    .\Publish-Module.ps1 -ModuleName MyModule -ApiKey $apiKey -WhatIf

.NOTES
    Author: Repository Maintainer
    License: MIT
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModuleName,

    [Parameter(Mandatory = $true)]
    [string]$ApiKey,

    [Parameter()]
    [string]$Repository = 'PSGallery'
)

$ErrorActionPreference = 'Stop'

Write-Host "Publishing module: $ModuleName" -ForegroundColor Cyan

# Validate module exists in output directory
$outputPath = Join-Path $PSScriptRoot ".." "output" $ModuleName
if (-not (Test-Path $outputPath)) {
    throw "Module '$ModuleName' not found in output directory: $outputPath. Please build the module first."
}

# Validate module manifest
$manifestPath = Join-Path $outputPath "$ModuleName.psd1"
if (-not (Test-Path $manifestPath)) {
    throw "Module manifest not found: $manifestPath"
}

Write-Host "✓ Module found at: $outputPath" -ForegroundColor Green

# Test module manifest
Write-Host "Testing module manifest..." -ForegroundColor Cyan
try {
    $manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop
    Write-Host "✓ Module manifest is valid" -ForegroundColor Green
    Write-Host "  Name: $($manifest.Name)" -ForegroundColor Gray
    Write-Host "  Version: $($manifest.Version)" -ForegroundColor Gray
    Write-Host "  Author: $($manifest.Author)" -ForegroundColor Gray
    Write-Host "  Description: $($manifest.Description)" -ForegroundColor Gray
}
catch {
    throw "Module manifest validation failed: $_"
}

# Check if module already exists in repository
Write-Host "`nChecking if module exists in $Repository..." -ForegroundColor Cyan
try {
    $existingModule = Find-Module -Name $ModuleName -Repository $Repository -ErrorAction SilentlyContinue
    if ($existingModule) {
        Write-Host "✓ Module exists in $Repository" -ForegroundColor Green
        Write-Host "  Current version: $($existingModule.Version)" -ForegroundColor Gray
        Write-Host "  New version: $($manifest.Version)" -ForegroundColor Gray
        
        if ($manifest.Version -le $existingModule.Version) {
            throw "New version ($($manifest.Version)) must be greater than current version ($($existingModule.Version))"
        }
    }
    else {
        Write-Host "✓ This will be the first publish of this module" -ForegroundColor Green
    }
}
catch {
    Write-Host "⚠ Could not check existing module: $_" -ForegroundColor Yellow
}

# Publish module
if ($PSCmdlet.ShouldProcess($ModuleName, "Publish to $Repository")) {
    Write-Host "`nPublishing module to $Repository..." -ForegroundColor Cyan
    
    try {
        Publish-Module -Path $outputPath -NuGetApiKey $ApiKey -Repository $Repository -ErrorAction Stop
        Write-Host "✓ Module published successfully!" -ForegroundColor Green
        Write-Host "`nModule URL: https://www.powershellgallery.com/packages/$ModuleName/$($manifest.Version)" -ForegroundColor Cyan
    }
    catch {
        throw "Failed to publish module: $_"
    }
}
else {
    Write-Host "`n[WhatIf] Would publish $ModuleName version $($manifest.Version) to $Repository" -ForegroundColor Yellow
}
