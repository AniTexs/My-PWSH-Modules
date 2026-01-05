<#
.SYNOPSIS
    Generates markdown documentation for a PowerShell module using PlatyPS.

.DESCRIPTION
    This script generates markdown documentation for a PowerShell module using the PlatyPS module.
    Documentation is generated in the docs\Module Documentation\{ModuleName}\{Version}\ directory.

.PARAMETER ModuleName
    The name of the module to generate documentation for.

.PARAMETER ModulePath
    The path to the module. If not specified, will look in ../modules/{ModuleName}.

.PARAMETER DocsPath
    The base path for documentation. Defaults to '../docs/Module Documentation'.

.EXAMPLE
    .\Generate-Docs.ps1 -ModuleName PS.Capa.CapaOne

.NOTES
    Author: Repository Maintainer
    License: MIT
    Requires: PlatyPS module (Install-Module PlatyPS)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModuleName,

    [Parameter()]
    [string]$ModulePath,

    [Parameter()]
    [string]$DocsPath = (Join-Path $PSScriptRoot ".." "docs" "Module Documentation")
)

$ErrorActionPreference = 'Stop'

Write-Host "Generating documentation for: $ModuleName" -ForegroundColor Cyan

# Import PlatyPS module
if (-not (Get-Module -ListAvailable -Name PlatyPS)) {
    throw "PlatyPS module is not installed. Please run: Install-Module PlatyPS -Scope CurrentUser"
}

Import-Module PlatyPS -ErrorAction Stop
Write-Host "✓ PlatyPS module loaded" -ForegroundColor Green

# Determine module path
if (-not $ModulePath) {
    $ModulePath = Join-Path $PSScriptRoot ".." "modules" $ModuleName
}

if (-not (Test-Path $ModulePath)) {
    throw "Module path not found: $ModulePath"
}

# Find module manifest
$manifestPath = Join-Path $ModulePath "$ModuleName.psd1"
if (-not (Test-Path $manifestPath)) {
    throw "Module manifest not found: $manifestPath"
}

Write-Host "✓ Module found at: $ModulePath" -ForegroundColor Green

# Import the module
Write-Host "Importing module for documentation generation..." -ForegroundColor Cyan
try {
    Import-Module $manifestPath -Force -ErrorAction Stop
    $moduleInfo = Get-Module $ModuleName
    $version = $moduleInfo.Version.ToString()
    Write-Host "✓ Module imported successfully (Version: $version)" -ForegroundColor Green
}
catch {
    throw "Failed to import module: $_"
}

# Create output directory
$outputPath = Join-Path $DocsPath $ModuleName $version
if (Test-Path $outputPath) {
    Write-Host "Removing existing documentation at: $outputPath" -ForegroundColor Yellow
    Remove-Item $outputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
Write-Host "✓ Created documentation directory: $outputPath" -ForegroundColor Green

# Generate markdown documentation
Write-Host "Generating markdown documentation..." -ForegroundColor Cyan
try {
    $commands = Get-Command -Module $ModuleName
    if ($commands.Count -eq 0) {
        Write-Warning "No commands found in module $ModuleName"
    }
    else {
        Write-Host "  Found $($commands.Count) command(s) to document" -ForegroundColor Gray
        
        # Generate markdown for all commands
        New-MarkdownHelp -Module $ModuleName -OutputFolder $outputPath -Force -ErrorAction Stop
        
        Write-Host "✓ Documentation generated successfully" -ForegroundColor Green
        Write-Host "  Location: $outputPath" -ForegroundColor Gray
        
        # List generated files
        $mdFiles = Get-ChildItem -Path $outputPath -Filter "*.md"
        if ($mdFiles) {
            Write-Host "`n  Generated files:" -ForegroundColor Gray
            foreach ($file in $mdFiles) {
                Write-Host "    - $($file.Name)" -ForegroundColor Gray
            }
        }
    }
}
catch {
    throw "Failed to generate documentation: $_"
}

# Commit documentation to git
Write-Host "`nCommitting documentation to git..." -ForegroundColor Cyan
try {
    # Check if git is available
    $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitAvailable) {
        Write-Warning "Git is not available. Documentation generated but not committed."
    }
    else {
        # Get relative path for git
        $repoRoot = Join-Path $PSScriptRoot ".."
        $relativePath = "docs/Module Documentation/$ModuleName/$version"
        
        # Change to repo root
        Push-Location $repoRoot
        try {
            # Add the documentation files
            git add $relativePath 2>&1 | Out-Null
            
            # Check if there are changes to commit
            $status = git status --porcelain $relativePath 2>&1
            if ($status) {
                # Commit with [skip ci] to avoid triggering CI/CD
                $commitMessage = "docs: Update documentation for $ModuleName v$version [skip ci]"
                git commit -m $commitMessage 2>&1 | Out-Null
                
                Write-Host "✓ Documentation committed to git" -ForegroundColor Green
                Write-Host "  Commit message: $commitMessage" -ForegroundColor Gray
            }
            else {
                Write-Host "✓ No documentation changes to commit" -ForegroundColor Green
            }
        }
        finally {
            Pop-Location
        }
    }
}
catch {
    Write-Warning "Failed to commit documentation: $_"
    Write-Warning "Documentation was generated but not committed."
}

Write-Host "`n✓ Documentation generation completed!" -ForegroundColor Green