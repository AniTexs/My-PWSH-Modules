# PS.ModelContextProtocol - Quick Reference

## Installation & Setup

```powershell
# 1. Import the module
Import-Module 'C:\PWSHDev\My-PWSH-Modules\modules\PS.ModelContextProtocol' -Verbose

# 2. Initialize the server (auto-discovers submodules)
Initialize-MCPServer -Verbose

# 3. Verify status
Get-MCPServerStatus
```

## Available Commands

### Server Management

```powershell
# Initialize/reinitialize the server
Initialize-MCPServer
Initialize-MCPServer -Force  # Reload all submodules
Initialize-MCPServer -Path 'C:\CustomModules'

# Check server status
Get-MCPServerStatus

# Manually register a submodule
Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.CustomTools'
Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.Legacy' -ModulePath 'C:\Legacy'
```

### Tool Discovery

```powershell
# Get all tools
Get-MCPTools

# Get tools by name pattern
Get-MCPTools -Name '*ActiveDirectory*'

# Get tools from specific submodule
Get-MCPTools -SubmoduleName 'PS.ModelContextProtocol.ActiveDirectory'
```

### Tool Invocation

```powershell
# Invoke a tool with arguments
Invoke-MCPTool -ToolName 'Get-ADUser-Info' -Arguments @{
    Identity = 'jdoe'
}

# Invoke with WhatIf
Invoke-MCPTool -ToolName 'Add-ADGroupMember' -Arguments @{
    GroupIdentity = 'Admins'
    UserIdentity = 'jdoe'
} -WhatIf
```

### Tool Definition Creation

```powershell
# Create a tool definition (for submodule authors)
$tool = New-MCPToolDefinition `
    -Name 'My-Tool' `
    -Description 'Does something useful' `
    -Handler { 
        param($Param1, $Param2)
        # Implementation here
    } `
    -InputSchema @{
        Param1 = 'Required parameter description'
        Param2 = 'Optional parameter description'
    } `
    -OutputDescription 'Returns a useful result'
```

## Common Workflows

### Check if Module Loads

```powershell
$module = Import-Module PS.ModelContextProtocol -PassThru
$module.Name
$module.ExportedFunctions
```

### Monitor Tool Discovery

```powershell
# See what tools are available
$tools = Get-MCPTools
$tools | ForEach-Object { "$($_.Name): $($_.Description)" }

# Count tools per submodule
$status = Get-MCPServerStatus
$status.Submodules | Format-Table Name, ToolCount
```

### Execute a Tool Safely

```powershell
try {
    $result = Invoke-MCPTool -ToolName 'MyTool' -Arguments @{
        Parameter1 = 'value'
    } -ErrorAction Stop
    
    $result
}
catch {
    Write-Error "Tool execution failed: $_"
}
```

### Create a Simple Submodule

```powershell
# Create directory
mkdir 'C:\PWSHDev\My-PWSH-Modules\modules\PS.ModelContextProtocol.MyTools'
mkdir 'C:\PWSHDev\My-PWSH-Modules\modules\PS.ModelContextProtocol.MyTools\Public'
mkdir 'C:\PWSHDev\My-PWSH-Modules\modules\PS.ModelContextProtocol.MyTools\Private'

# Create Get-MCPTools.ps1 in Public folder
# Return tool definitions using New-MCPToolDefinition

# Create .psd1 manifest

# Create .psm1 root module

# Next time Initialize-MCPServer runs, it auto-discovers your module
```

## Troubleshooting

### Module doesn't load

```powershell
# Check if module path exists
Test-Path 'C:\PWSHDev\My-PWSH-Modules\modules\PS.ModelContextProtocol'

# Try importing with verbose output
Import-Module PS.ModelContextProtocol -Verbose -ErrorAction Stop

# Check for syntax errors
Test-ModuleManifest 'C:\PWSHDev\My-PWSH-Modules\modules\PS.ModelContextProtocol\PS.ModelContextProtocol.psd1'
```

### Submodule not discovered

```powershell
# Check if module is in correct location and named correctly
Get-ChildItem -Path (Get-Module PS.ModelContextProtocol).ModuleBase -Filter 'PS.ModelContextProtocol.*'

# Verify submodule has Get-MCPTools function
Get-Command -Module 'PS.ModelContextProtocol.YourModule' | Where-Object Name -eq 'Get-MCPTools'

# Try explicit registration
Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.YourModule' -Verbose
```

### Tool not available

```powershell
# List all tools with details
Get-MCPTools | Select-Object Name, Description, SubmoduleName

# Check specific submodule
$status = Get-MCPServerStatus
$status.Submodules | Format-List

# Reinitialize server
Initialize-MCPServer -Force -Verbose
```

## File Structure Overview

```
PS.ModelContextProtocol/
├── Public/                              (Exported functions)
│   ├── Initialize-MCPServer.ps1
│   ├── Get-MCPTools.ps1
│   ├── Invoke-MCPTool.ps1
│   ├── Register-MCPSubmodule.ps1
│   ├── Get-MCPServerStatus.ps1
│   └── New-MCPToolDefinition.ps1
│
├── Private/                             (Internal functions)
│   └── Test-MCPToolDefinition.ps1
│
├── PS.ModelContextProtocol.psd1         (Module manifest)
├── PS.ModelContextProtocol.psm1         (Root module)
├── README.md                            (Full documentation)
├── SUBMODULE_TEMPLATE.md               (How to create submodules)
├── CHANGELOG.md                         (Version history)
├── IMPLEMENTATION_SUMMARY.md            (Architecture overview)
└── QUICK_REFERENCE.md                  (This file)
```

## Getting Help

```powershell
# Help for any function
Get-Help Initialize-MCPServer -Full
Get-Help Get-MCPTools -Full
Get-Help Invoke-MCPTool -Full
Get-Help Register-MCPSubmodule -Full
Get-Help Get-MCPServerStatus -Full
Get-Help New-MCPToolDefinition -Full

# View function synopsis
Get-Help Initialize-MCPServer -Detailed
```

## Key Concepts

### Global MCP Context
```powershell
# Accessible after Initialize-MCPServer
$PSMCPContext.Tools              # All registered tools (by name)
$PSMCPContext.Submodules         # All loaded submodules (by name)
$PSMCPContext.TotalTools         # Count of tools
$PSMCPContext.TotalSubmodules    # Count of submodules
```

### Tool Structure
```powershell
Tool Definition Properties:
- Name: Unique tool identifier
- Description: What the tool does
- Handler: Scriptblock or function to execute
- InputSchema: Hashtable of parameter descriptions
- OutputDescription: What the tool returns
- SubmoduleName: Which submodule provides it
- CreatedAt: When the tool was registered
```

### Submodule Contract
- Must be named: `PS.ModelContextProtocol.{SubmoduleName}`
- Must export: `Get-MCPTools` function
- Must return: Array of tool definitions created with `New-MCPToolDefinition`
- Should handle: Errors gracefully (return objects, not throw)

---

**Version**: 0.1.0  
**Last Updated**: January 13, 2026  
**For Full Documentation**: See README.md
