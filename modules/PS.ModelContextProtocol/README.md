# PS.ModelContextProtocol MCP Server

A PowerShell-based Model Context Protocol (MCP) server and runtime that allows AI Agents to access and interact with PowerShell tools and functionality through a standardized protocol.

## Overview

This module provides the foundation for building MCP servers in PowerShell. It enables:

- **Automatic submodule discovery**: Find and load `PS.ModelContextProtocol.*` submodules automatically
- **Tool registration**: Register tools that AI agents can invoke
- **Tool invocation**: Execute registered tools with provided arguments
- **Status tracking**: Monitor server status and loaded tools

## Architecture

```
PS.ModelContextProtocol (Base)
├── Initialize-MCPServer          (Setup and discovery)
├── Get-MCPTools                  (Query available tools)
├── Invoke-MCPTool                (Execute tools)
├── Register-MCPSubmodule         (Manual registration)
├── Get-MCPServerStatus           (Status information)
└── New-MCPToolDefinition         (Tool definition factory)

PS.ModelContextProtocol.* (Submodules)
├── Get-MCPTools                  (Required export)
└── [Tool implementations]         (User-defined)
```

## Quick Start

### 1. Initialize the MCP Server

```powershell
Import-Module PS.ModelContextProtocol
Initialize-MCPServer
```

This will automatically discover and load all `PS.ModelContextProtocol.*` submodules in the module path.

### 2. Check Available Tools

```powershell
Get-MCPTools
# If you have loaded submodules that also export Get-MCPTools, you can force the base module version like this:
PS.ModelContextProtocol\Get-MCPTools
Get-MCPTools -Name '*ActiveDirectory*'
Get-MCPServerStatus
```

### 3. Invoke a Tool

```powershell
$result = Invoke-MCPTool -ToolName 'ps_mcp_example_echo' -Arguments @{
    Text = 'hello'
}
```

## Creating a Submodule

Submodules follow a simple pattern. Here's an example structure for `PS.ModelContextProtocol.ActiveDirectory`:

### Submodule Structure

```
PS.ModelContextProtocol.ActiveDirectory/
├── PS.ModelContextProtocol.ActiveDirectory.psd1
├── PS.ModelContextProtocol.ActiveDirectory.psm1
├── Public/
│   ├── Get-MCPTools.ps1
│   └── [Tool implementation files]
└── Private/
    └── [Helper functions]
```

### Submodule Manifest (psd1)

```powershell
@{
    RootModule = 'PS.ModelContextProtocol.ActiveDirectory.psm1'
    ModuleVersion = '1.0.0'
    GUID = '[unique-guid]'
    Author = 'Your Name'
    Description = 'Active Directory tools for MCP'
    FunctionsToExport = @('Get-MCPTools')
    # ... other manifest properties
}
```

### Submodule Implementation (psm1)

```powershell
# Import helper functions
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
```

### Get-MCPTools Implementation

The `Get-MCPTools` function is **required** and must return an array of tool definitions:

```powershell
# Public/Get-MCPTools.ps1
function Get-MCPTools {
    <#
        .SYNOPSIS
        Returns all MCP tools provided by this submodule.
    #>
    $tools = @()

    # Define Get-ADUser tool
    $tools += New-MCPToolDefinition `
        -Name 'ps_mcp_activedirectory_getUser' `
        -Description 'Retrieves information about an Active Directory user' `
        -Handler {
            param($Identity)
            
            # Validate input
            if (-not $Identity) {
                throw "Identity parameter is required"
            }

            try {
                Get-ADUser -Identity $Identity -Properties *
            }
            catch {
                @{ Error = $_.Exception.Message }
            }
        } `
        -InputSchema @{
            Identity = 'The user identity (username, email, or SID). Required.'
        } `
        -OutputDescription 'Returns PSObject with user properties or error object'

    # Define Search-ADUser tool
    $tools += New-MCPToolDefinition `
        -Name 'ps_mcp_activedirectory_searchUsers' `
        -Description 'Searches for Active Directory users matching a filter' `
        -Handler {
            param($Filter, $SearchBase, $MaxResults = 100)
            
            $params = @{
                Filter = $Filter
                ResultSetSize = $MaxResults
            }
            
            if ($SearchBase) {
                $params['SearchBase'] = $SearchBase
            }

            try {
                Get-ADUser @params -Properties * | Select-Object -First $MaxResults
            }
            catch {
                @{ Error = $_.Exception.Message }
            }
        } `
        -InputSchema @{
            Filter = 'LDAP filter string (e.g., "(givenName=John)"). Required.'
            SearchBase = 'The search base DN. Optional.'
            MaxResults = 'Maximum number of results to return. Defaults to 100.'
        } `
        -OutputDescription 'Returns array of user objects matching the filter'

    return $tools
}
```

## Tool Definition Format

Tools are defined using `New-MCPToolDefinition` with the following properties:

```powershell
@{
    Name                = 'Tool-Name'                          # Unique identifier
    Description         = 'What the tool does'                  # Human-readable description
    Handler             = { param(...) ... }                   # Scriptblock or function name
    InputSchema         = @{ param1 = 'desc'; param2 = 'desc' } # Parameter descriptions
    OutputDescription   = 'What the tool returns'              # Optional
    SubmoduleName       = 'PS.ModelContextProtocol.ModuleName' # Auto-populated
    CreatedAt          = [datetime]                            # Auto-populated
}
```

## Best Practices for Submodule Authors

1. **Error Handling**: Always wrap tool handlers in try-catch blocks. Return error objects for graceful failure.

2. **Input Validation**: Validate inputs early in your handler before executing operations.

3. **Output Format**: Return consistent, serializable output (avoid complex objects when possible).

4. **Documentation**: Include clear descriptions of what each tool does and what parameters it accepts.

5. **Scope Awareness**: Consider tenant/organizational scope when accessing shared resources.

6. **Logging**: Use Write-Verbose for diagnostic information.

```powershell
$tools += New-MCPToolDefinition `
    -Name 'Example-Tool' `
    -Description 'Example tool with best practices' `
    -Handler {
        param($RequiredParam, $OptionalParam)
        
        # Validate required parameters
        if (-not $RequiredParam) {
            return @{ Error = 'RequiredParam is required' }
        }

        try {
            Write-Verbose "Executing Example-Tool with RequiredParam=$RequiredParam"
            
            # Implement tool logic
            $result = Get-Something -Filter $RequiredParam
            
            # Return success
            @{ Success = $true; Data = $result }
        }
        catch {
            Write-Verbose "Example-Tool failed: $_"
            return @{ Error = $_.Exception.Message }
        }
    } `
    -InputSchema @{
        RequiredParam = 'Description of required parameter'
        OptionalParam = 'Description of optional parameter'
    } `
    -OutputDescription 'Returns @{Success=[bool]; Data=[object]} or @{Error=[string]}'
```

## Advanced Usage

### Manual Submodule Registration

If a submodule is not in the standard module path:

```powershell
Register-MCPSubmodule `
    -ModuleName 'PS.ModelContextProtocol.CustomTools' `
    -ModulePath 'C:\CustomModules\CustomTools'
```

### Reinitializing the Server

Force reload all submodules:

```powershell
Initialize-MCPServer -Force
```

### Checking Server Status

```powershell
$status = Get-MCPServerStatus
$status.TotalTools
$status.Submodules | Format-Table
```

## Integration with AI Agents

Once initialized, the MCP server exposes tools through the global `$PSMCPContext` variable:

```powershell
$PSMCPContext.Tools          # All registered tools
$PSMCPContext.Submodules     # Loaded submodules
$PSMCPContext.ToolCount      # Total tools
```

AI agents can:
1. Query available tools via `Get-MCPTools`
2. Inspect tool schemas via the returned tool definitions
3. Invoke tools via `Invoke-MCPTool` with appropriate arguments

## Troubleshooting

### Submodule Not Loading

```powershell
# Check if module is discoverable
Get-Module -ListAvailable -Name 'PS.ModelContextProtocol.*'

# Verify Get-MCPTools is exported
Get-Command -Module 'PS.ModelContextProtocol.YourModule' | Where-Object Name -eq 'Get-MCPTools'

# Check for errors during import
Initialize-MCPServer -Verbose
```

### Tool Not Available

```powershell
# List all registered tools
Get-MCPTools

# Check specific submodule
$status = Get-MCPServerStatus
$status.Submodules | Where-Object Name -eq 'PS.ModelContextProtocol.YourModule'
```

## Version History

- **0.1.0** (2026-01-13): Initial release with core MCP server functionality
