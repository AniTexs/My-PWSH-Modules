function Get-MCPTools {
    <#
        .SYNOPSIS
        Returns MCP tools provided by PS.ModelContextProtocol.Example.

        .DESCRIPTION
        This is the required entrypoint for any PS.ModelContextProtocol.* submodule.
        The base module calls this function during Initialize-MCPServer to discover tools.

        .EXAMPLE
        Get-MCPTools
    #>
    [CmdletBinding()]
    param()

    try {
        if (-not (Get-Command -Name 'New-MCPToolDefinition' -ErrorAction SilentlyContinue)) {
            throw "New-MCPToolDefinition not found. Ensure PS.ModelContextProtocol is imported before using this submodule."
        }

        $tools = @(
            New-MCPToolDefinition `
                -Name "ps_mcp_powershell_modules_list" `
                -Description "Lists all installed PowerShell modules on the server." `
                -Handler {
                    param()

                    try {
                        $modules = Get-Module -ListAvailable | Select-Object Name, Version, Path
                        return @{
                            Success = $true
                            Modules = $modules
                        }
                    }
                    catch {
                        return @{
                            Success = $false
                            Error   = $_.Exception.Message
                        }
                    }
                } `
                -InputSchema @{} `
                -OutputDescription "Returns @{ Success=[bool]; Modules=[array of PSModuleInfo] | Error=[string] }"
            New-MCPToolDefinition `
                -Name "ps_mcp_powershell_execute_command" `
                -Description "Executes a PowerShell command on the server and returns the output." `
                -Handler {
                    param(
                        [Parameter(Mandatory)]
                        [string]$Command
                    )
                    try {
                        $output = Invoke-Expression -Command $Command
                        return @{
                            Success = $true
                            Output  = $output
                        }
                    }
                    catch {
                        return @{
                            Success = $false
                            Error   = $_.Exception.Message
                        }
                    }
                } `
                -InputSchema @{
                    Command = "A scriptblock representing the PowerShell command to execute. Required."
                } `
                -OutputDescription "Returns @{ Success=[bool]; Output=[object] | Error=[string] }"
                
        )

        return $tools
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
