function Get-MCPTools {
    <#
        .SYNOPSIS
        Retrieves all available MCP tools from loaded submodules.

        .DESCRIPTION
        Returns a list of all tools that have been registered by submodules.
        Each tool includes its name, description, input schema, and handler function.

        .PARAMETER Name
        Optional. Filter tools by name pattern.

        .PARAMETER SubmoduleName
        Optional. Filter tools by the submodule that provides them.

        .EXAMPLE
        Get-MCPTools

        .EXAMPLE
        Get-MCPTools -Name '*ActiveDirectory*'

        .EXAMPLE
        Get-MCPTools -SubmoduleName 'PS.ModelContextProtocol.ActiveDirectory'

        .NOTES
        This function returns tools from the global MCP context that was initialized by Initialize-MCPServer.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$SubmoduleName
    )

    try {
        if (-not (Get-Variable -Name PSMCPContext -Scope Global -ErrorAction SilentlyContinue)) {
            Write-Warning "MCP server not initialized. Call Initialize-MCPServer first."
            return
        }

        $tools = $global:PSMCPContext.Tools.Values

        # Filter by name if provided
        if ($Name) {
            $tools = $tools | Where-Object { $_.Name -like $Name }
        }

        # Filter by submodule if provided
        if ($SubmoduleName) {
            $tools = $tools | Where-Object { $_.SubmoduleName -eq $SubmoduleName }
        }

        return $tools
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
