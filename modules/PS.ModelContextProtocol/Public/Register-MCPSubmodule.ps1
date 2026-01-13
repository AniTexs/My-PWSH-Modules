function Register-MCPSubmodule {
    <#
        .SYNOPSIS
        Manually registers an MCP submodule that may not have been auto-discovered.

        .DESCRIPTION
        Allows explicit registration of a submodule module, even if it's not in the default module path.
        Useful for dynamic module loading or modules installed in non-standard locations.

        .PARAMETER ModuleName
        The name of the module to register. Should follow PS.ModelContextProtocol.* naming convention.

        .PARAMETER ModulePath
        Optional. The full path to the module if not in the standard module search paths.

        .EXAMPLE
        Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.CustomTools'

        .EXAMPLE
        Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.LegacyAD' -ModulePath 'C:\CustomModules\LegacyAD'

        .NOTES
        The submodule must export a Get-MCPTools function to be valid.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$ModuleName,

        [Parameter()]
        [string]$ModulePath
    )

    try {
        if (-not (Get-Variable -Name PSMCPContext -Scope Global -ErrorAction SilentlyContinue)) {
            throw "MCP server not initialized. Call Initialize-MCPServer first."
        }

        Write-Verbose "Attempting to register submodule: $ModuleName"

        # Import or get the module
        $module = Get-Module -Name $ModuleName -ErrorAction SilentlyContinue
        if (-not $module) {
            if ($ModulePath) {
                $importTarget = $ModulePath

                if (Test-Path -Path $ModulePath -PathType Container) {
                    $manifestCandidate = Join-Path -Path $ModulePath -ChildPath ($ModuleName + '.psd1')
                    if (Test-Path -Path $manifestCandidate) {
                        $importTarget = $manifestCandidate
                    }
                    else {
                        $importTarget = (Get-ChildItem -Path $ModulePath -Filter '*.psd1' -File -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
                    }
                }

                if (-not $importTarget) {
                    throw "ModulePath was provided but no module manifest (.psd1) could be resolved for '$ModuleName'"
                }

                $module = Import-Module -Name $importTarget -Force -PassThru -ErrorAction Stop
            }
            else {
                $module = Import-Module -Name $ModuleName -Force -PassThru -ErrorAction Stop
            }
        }

        if (-not $module) {
            throw "Failed to import module: $ModuleName"
        }

        if ($PSCmdlet.ShouldProcess($ModuleName, 'Register MCP submodule')) {
            # Check for Get-MCPTools function
            $getToolsCommand = Get-Command -Module $ModuleName -Name 'Get-MCPTools' -ErrorAction SilentlyContinue
            if ($getToolsCommand) {
                Write-Verbose "Retrieving tools from submodule: $ModuleName"

                # Get tools from the submodule
                $tools = & $getToolsCommand

                if ($tools) {
                    $global:PSMCPContext.Submodules[$ModuleName] = @{
                        Module       = $module
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

                    Write-Verbose "Registered $($tools.Count) tool(s) from $ModuleName"
                    return $true
                }
            }
            else {
                throw "Module '$ModuleName' does not export Get-MCPTools function"
            }
        }
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
