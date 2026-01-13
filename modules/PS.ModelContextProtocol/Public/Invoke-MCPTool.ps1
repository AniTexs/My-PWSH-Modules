function Invoke-MCPTool {
    <#
        .SYNOPSIS
        Executes an MCP tool by name with provided arguments.

        .DESCRIPTION
        Invokes a registered MCP tool with the specified input parameters.
        The tool must have been registered via Initialize-MCPServer.

        .PARAMETER ToolName
        The name of the tool to execute. Must be an exact match.

        .PARAMETER Arguments
        A hashtable of arguments to pass to the tool. The keys must match the tool's input schema.

        .EXAMPLE
        $result = Invoke-MCPTool -ToolName 'Get-ADUser' -Arguments @{ Identity = 'jdoe' }

        .EXAMPLE
        Invoke-MCPTool -ToolName 'Search-ADObject' -Arguments @{
            Filter = '(objectClass=user)'
            SearchBase = 'OU=Users,DC=example,DC=com'
        }

        .NOTES
        This function will throw an error if the tool is not found or if execution fails.
        The tool handler is responsible for validating input against the schema.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$ToolName,

        [Parameter()]
        [hashtable]$Arguments = @{}
    )

    try {
        if (-not (Get-Variable -Name PSMCPContext -Scope Global -ErrorAction SilentlyContinue)) {
            throw "MCP server not initialized. Call Initialize-MCPServer first."
        }

        $tool = $global:PSMCPContext.Tools[$ToolName]
        if (-not $tool) {
            throw "Tool '$ToolName' not found. Available tools: $($global:PSMCPContext.Tools.Keys -join ', ')"
        }

        if ($PSCmdlet.ShouldProcess($ToolName, 'Invoke MCP tool')) {
            Write-Verbose "Invoking tool: $ToolName with arguments: $($Arguments | ConvertTo-Json)"

            # Invoke the tool handler
            if ($tool.Handler -is [scriptblock]) {
                $result = & $tool.Handler @Arguments
            }
            elseif ($tool.Handler -is [string]) {
                # If handler is a function name, invoke it
                $result = & $tool.Handler @Arguments
            }
            else {
                throw "Tool handler for '$ToolName' is not a valid scriptblock or function name"
            }

            Write-Verbose "Tool execution completed successfully"
            return $result
        }
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
