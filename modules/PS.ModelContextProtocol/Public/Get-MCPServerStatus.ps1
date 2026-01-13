function Get-MCPServerStatus {
    <#
        .SYNOPSIS
        Returns the current status and statistics of the MCP server.

        .DESCRIPTION
        Provides detailed information about the initialized MCP server including:
        - Initialization status
        - Number of loaded submodules
        - Number of registered tools
        - Details about each submodule

        .EXAMPLE
        Get-MCPServerStatus

        .NOTES
        Returns $null if the MCP server has not been initialized.
    #>
    [CmdletBinding()]
    param()

    try {
        $context = Get-Variable -Name PSMCPContext -Scope Global -ErrorAction SilentlyContinue -ValueOnly

        if (-not $context) {
            Write-Warning "MCP server not initialized"
            return $null
        }

        $status = @{
            Initialized      = $context.Initialized
            TotalTools       = $context.Tools.Count
            TotalSubmodules  = $context.Submodules.Count
            ModulePath       = $context.ModulePath
            InitializedAt    = $context.LoadedAt
            Submodules       = @()
        }

        # Add submodule details
        foreach ($submoduleName in $context.Submodules.Keys) {
            $submodule = $context.Submodules[$submoduleName]
            $status.Submodules += @{
                Name      = $submoduleName
                ToolCount = $submodule.ToolCount
                LoadedAt  = $submodule.LoadedAt
            }
        }

        return $status
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
