function Initialize-MCPServer {
    <#
        .SYNOPSIS
        Initializes the MCP (Model Context Protocol) server and discovers available submodules.

        .DESCRIPTION
        Sets up the MCP server infrastructure and automatically discovers and registers all PS.ModelContextProtocol.* submodules.
        Each submodule should export a Get-MCPTools function that returns available tools for AI agents.

        .PARAMETER Path
        The path where PS.ModelContextProtocol submodules are installed. Defaults to the Modules directory containing this module.

        .PARAMETER Force
        If specified, reinitializes the MCP server and reloads all submodules.

        .EXAMPLE
        Initialize-MCPServer
        
        Initialize-MCPServer -Path 'C:\MyModules'

        .EXAMPLE
        Initialize-MCPServer -Force

        .NOTES
        Submodules should follow this naming convention: PS.ModelContextProtocol.{SubModuleName}
        Each submodule must export a Get-MCPTools function that returns tool definitions.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [string]$Path,

        [Parameter()]
        [switch]$Force
    )

    try {
        # Determine the module path
        if (-not $Path) {
            $Path = Split-Path -Parent (Get-Module PS.ModelContextProtocol).ModuleBase
        }

        Write-Verbose "Initializing MCP server with module path: $Path"

        # Initialize or clear the global MCP context
        if ($Force -or -not (Get-Variable -Name PSMCPContext -Scope Global -ErrorAction SilentlyContinue)) {
            Write-Verbose "Creating new MCP context"
            $global:PSMCPContext = @{
                Initialized  = $true
                Submodules   = @{}
                Tools        = @{}
                ModulePath   = $Path
                LoadedAt     = Get-Date
            }
        }

        # Discover and load submodules
        # Note: On Windows, patterns like 'Foo.*' can also match 'Foo' (no extension),
        # so we do an explicit regex check to ensure we only match true submodules.
        $discoveredModules = Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '^PS\.ModelContextProtocol\..+' }

        if ($discoveredModules) {
            Write-Verbose "Found $($discoveredModules.Count) submodule(s)"

            foreach ($module in $discoveredModules) {
                $moduleName = $module.Name
                Write-Verbose "Loading submodule: $moduleName"

                try {
                    # Resolve a manifest path to import (Import-Module does not support -Path)
                    $manifestCandidate = Join-Path -Path $module.FullName -ChildPath ($moduleName + '.psd1')
                    if (Test-Path -Path $manifestCandidate) {
                        $moduleImportPath = $manifestCandidate
                    }
                    else {
                        $moduleImportPath = (Get-ChildItem -Path $module.FullName -Filter '*.psd1' -File -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
                    }

                    if (-not $moduleImportPath) {
                        throw "No module manifest (.psd1) found under '$($module.FullName)'"
                    }

                    # Import the submodule
                    $importedModule = Import-Module -Name $moduleImportPath -Force -PassThru -ErrorAction Stop

                    if ($importedModule) {
                        # Check if the submodule has a Get-MCPTools function
                        $getToolsCommand = Get-Command -Module $moduleName -Name 'Get-MCPTools' -ErrorAction SilentlyContinue
                        if ($getToolsCommand) {
                            Write-Verbose "Registering tools from submodule: $moduleName"

                            # Get tools from the submodule
                            $tools = & $getToolsCommand

                            if ($tools) {
                                $global:PSMCPContext.Submodules[$moduleName] = @{
                                    Module       = $importedModule
                                    ToolCount   = $tools.Count
                                    Tools        = $tools
                                    LoadedAt    = Get-Date
                                }

                                # Register tools in the global context
                                foreach ($tool in $tools) {
                                    if ($tool.Name) {
                                        $global:PSMCPContext.Tools[$tool.Name] = $tool
                                    }
                                }

                                Write-Verbose "Registered $($tools.Count) tool(s) from $moduleName"
                            }
                        }
                        else {
                            Write-Warning "Submodule '$moduleName' does not export Get-MCPTools function"
                        }
                    }
                }
                catch {
                    Write-Warning "Failed to load submodule '$moduleName': $_"
                }
            }
        }
        else {
            Write-Verbose "No PS.ModelContextProtocol submodules found in: $Path"
        }

        Write-Verbose "MCP server initialized with $($global:PSMCPContext.Tools.Count) tools"
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
