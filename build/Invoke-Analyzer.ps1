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

# Function to extract imported modules from PowerShell files
function Get-ImportedModules {
    param(
        [string]$Path
    )
    
    $importedModules = @{}
    
    # Get all PS files recursively
    $psFiles = Get-ChildItem -Path $Path -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $psFiles) {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        # Find Import-Module statements
        $importMatches = [regex]::Matches($content, "Import-Module\s+(?:-Name\s+)?['\`"]?([a-zA-Z0-9._-]+)['\`"]?", "IgnoreCase")
        foreach ($match in $importMatches) {
            $moduleName = $match.Groups[1].Value
            if ($moduleName -and $moduleName -notin $importedModules.Keys) {
                $importedModules[$moduleName] = @{ File = $file.Name; Type = 'Import-Module' }
            }
        }
        
        # Find using module statements
        $usingMatches = [regex]::Matches($content, "using\s+module\s+['\`"]?([a-zA-Z0-9._\\/:-]+)['\`"]?", "IgnoreCase")
        foreach ($match in $usingMatches) {
            $moduleName = Split-Path $match.Groups[1].Value -Leaf
            if ($moduleName -and $moduleName -notin $importedModules.Keys) {
                $importedModules[$moduleName] = @{ File = $file.Name; Type = 'using module' }
            }
        }
        
        # Find #Requires -Module statements
        $requiresMatches = [regex]::Matches($content, "#Requires\s+-Module\s+([a-zA-Z0-9._-]+)", "IgnoreCase")
        foreach ($match in $requiresMatches) {
            $moduleName = $match.Groups[1].Value
            if ($moduleName -and $moduleName -notin $importedModules.Keys) {
                $importedModules[$moduleName] = @{ File = $file.Name; Type = '#Requires' }
            }
        }
    }
    
    return $importedModules
}

# Function to detect cmdlet usage from modules
function Get-CmdletUsage {
    param(
        [string]$Path,
        [hashtable]$ImportedModules
    )
    
    $usedModules = @{}
    
    # Get all PS files recursively
    $psFiles = Get-ChildItem -Path $Path -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $psFiles) {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        # Build a pattern of known module cmdlets
        foreach ($moduleName in $ImportedModules.Keys) {
            # Common cmdlet patterns: Verb-Noun format
            # Look for cmdlet calls with module prefix or just cmdlet names
            $pattern = "(?:^|\s)(?:\[?$([regex]::Escape($moduleName))\.)?\b([A-Z][a-z]+-[A-Z][a-zA-Z0-9]+)"
            
            $matches = [regex]::Matches($content, $pattern, "Multiline")
            if ($matches.Count -gt 0) {
                if ($moduleName -notin $usedModules) {
                    $usedModules[$moduleName] = @{ File = $file.Name; UsageCount = $matches.Count }
                }
                else {
                    $usedModules[$moduleName].UsageCount += $matches.Count
                }
            }
        }
    }
    
    return $usedModules
}

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
    
    # Run PSScriptAnalyzer
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
        Write-Host "  ✓ No script analysis issues found" -ForegroundColor Green
    }
    
    # Analyze module dependencies
    Write-Host "`n  Module Dependencies:" -ForegroundColor Cyan
    $importedModules = Get-ImportedModules -Path $path
    $usedModules = Get-CmdletUsage -Path $path -ImportedModules $importedModules
    
    if ($importedModules.Count -eq 0) {
        Write-Host "    ℹ No modules imported" -ForegroundColor Gray
    }
    else {
        Write-Host "    Imported modules:" -ForegroundColor Cyan
        foreach ($modName in ($importedModules.Keys | Sort-Object)) {
            $importInfo = $importedModules[$modName]
            $isUsed = $modName -in $usedModules.Keys
            $status = if ($isUsed) { "✓ Used" } else { "⚠ Unused" }
            $statusColor = if ($isUsed) { "Green" } else { "Yellow" }
            
            Write-Host "      [$status] $modName" -ForegroundColor $statusColor
            Write-Host "        Type: $($importInfo.Type), First found in: $($importInfo.File)" -ForegroundColor Gray
        }
    }
    
    # Check for potential missing imports (used but not imported)
    Write-Host "`n    External cmdlets analysis:" -ForegroundColor Cyan
    
    $psFiles = Get-ChildItem -Path $path -Filter "*.ps1" -Recurse -ErrorAction SilentlyContinue
    $commonCmdlets = @()
    
    foreach ($file in $psFiles) {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        # Find all cmdlet-like calls (Verb-Noun pattern)
        $cmdletMatches = [regex]::Matches($content, "\b([A-Z][a-z]+-[A-Z][a-zA-Z0-9]+)\b")
        $commonCmdlets += $cmdletMatches | ForEach-Object { $_.Groups[1].Value }
    }
    
    if ($commonCmdlets.Count -gt 0) {
        $uniqueCmdlets = @($commonCmdlets | Sort-Object -Unique)
        Write-Host "      Found $($uniqueCmdlets.Count) unique cmdlets across module files" -ForegroundColor Gray
        
        # Show summary
        if ($usedModules.Count -eq 0 -and $importedModules.Count -gt 0) {
            Write-Host "      ⚠ Warning: Modules imported but no usage detected" -ForegroundColor Yellow
        }
        elseif ($usedModules.Count -eq 0) {
            Write-Host "      ℹ No external module usage detected" -ForegroundColor Gray
        }
        else {
            Write-Host "      ✓ Using $($usedModules.Count) imported module(s)" -ForegroundColor Green
        }
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
