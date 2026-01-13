[CmdletBinding()]
param(
    [Parameter()]
    [string]$ModulePath
)

$ErrorActionPreference = 'Stop'

# Import the module by manifest path (stable regardless of PSModulePath)
$manifest = Join-Path -Path $PSScriptRoot -ChildPath 'PS.ModelContextProtocol.psd1'
Import-Module -Name $manifest -Force

if (-not $ModulePath) {
    # The parent folder of this module folder should be the "modules" folder
    $ModulePath = Split-Path -Parent $PSScriptRoot
}

# Ensure the spawned process can discover modules and RequiredModules dependencies.
# VS Code typically spawns pwsh with -NoProfile, so PSModulePath may be minimal.
if ($env:PSModulePath -notlike "${ModulePath};*") {
    $env:PSModulePath = "${ModulePath};$env:PSModulePath"
}

# Start STDIO server loop
Start-MCPStdioServer -ModulePath $ModulePath -ForceInitialize
