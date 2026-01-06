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

$ErrorActionPreference = 'Continue'

Write-Host "Generating documentation for: $ModuleName" -ForegroundColor Cyan

# Import PlatyPS module
try {
    Import-Module PlatyPS -ErrorAction Stop
    Write-Host "✓ PlatyPS module loaded" -ForegroundColor Green
}
catch {
    # Check if module is available
    $platyPS = Get-Module -ListAvailable -Name PlatyPS
    if (-not $platyPS) {
        throw "PlatyPS module is not installed. Please run: Install-Module PlatyPS -Scope CurrentUser"
    }
    else {
        throw "Failed to import PlatyPS module: $_"
    }
}

# Determine module path
if (-not $ModulePath) {
    $ModulePath = Join-Path $PSScriptRoot ".." "modules" $ModuleName
}

if (-not (Test-Path $ModulePath)) {
    Write-Error "Module path not found: $ModulePath"
    exit 1
}

# Find module manifest
$manifestPath = Join-Path $ModulePath "$ModuleName.psd1"
if (-not (Test-Path $manifestPath)) {
    Write-Error "Module manifest not found: $manifestPath"
    exit 1
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
    Write-Error "Failed to import module: $_"
    exit 1
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
        # Use ErrorAction Continue to generate what we can even if some commands fail
        # Suppress type-not-found warnings since PlatyPS can still generate documentation
        $WarningPreference = 'SilentlyContinue'
        New-MarkdownHelp -Module $ModuleName -OutputFolder $outputPath -Force -ErrorAction Continue -WarningAction SilentlyContinue
        $WarningPreference = 'Continue'
        
        Write-Host "✓ Documentation generation completed" -ForegroundColor Green
        Write-Host "  Location: $outputPath" -ForegroundColor Gray
        
        # List generated files
        $mdFiles = Get-ChildItem -Path $outputPath -Filter "*.md"
        if ($mdFiles) {
            Write-Host "`n  Generated files:" -ForegroundColor Gray
            foreach ($file in $mdFiles) {
                Write-Host "    - $($file.Name)" -ForegroundColor Gray
            }
        }
        else {
            Write-Warning "No markdown files were generated"
        }
    }
}
catch {
    # Check if the error is related to type resolution - this is non-critical
    if ($_ -match "Unable to find type") {
        Write-Warning "Type resolution warning (non-critical): $_"
        
        # Check if files were generated despite the type error
        $mdFiles = Get-ChildItem -Path $outputPath -Filter "*.md" -ErrorAction SilentlyContinue
        if ($mdFiles) {
            Write-Host "✓ Documentation was generated ($($mdFiles.Count) file(s)) despite type resolution warnings" -ForegroundColor Green
        }
        else {
            Write-Warning "No markdown files were generated"
        }
    }
    else {
        Write-Warning "Non-critical error during documentation generation: $_"
        
        # Check if any files were generated despite the error
        $mdFiles = Get-ChildItem -Path $outputPath -Filter "*.md" -ErrorAction SilentlyContinue
        if ($mdFiles) {
            Write-Host "✓ Partial documentation was generated ($($mdFiles.Count) file(s))" -ForegroundColor Green
        }
        else {
            throw "Failed to generate documentation: $_"
        }
    }
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
exit 0