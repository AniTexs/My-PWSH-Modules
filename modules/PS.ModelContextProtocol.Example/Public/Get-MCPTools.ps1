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

        $tools = @()

            $tools += New-MCPToolDefinition `
                -Name 'ps_mcp_example_echo' `
            -Description 'Echoes the provided text back to the caller.' `
            -Handler {
                param(
                    [Parameter(Mandatory)]
                    [string]$Text
                )

                return @{
                    Success = $true
                    Text    = $Text
                }
            } `
            -InputSchema @{
                Text = 'Text to echo back. Required.'
            } `
            -OutputDescription 'Returns @{ Success=[bool]; Text=[string] }'

            $tools += New-MCPToolDefinition `
                -Name 'ps_mcp_example_getTime' `
            -Description 'Returns the current server time in ISO 8601 format.' `
            -Handler {
                param(
                    [string]$TimeZoneId
                )

                try {
                    if ($TimeZoneId) {
                        $tz = [System.TimeZoneInfo]::FindSystemTimeZoneById($TimeZoneId)
                        $local = [System.TimeZoneInfo]::ConvertTimeFromUtc([DateTime]::UtcNow, $tz)
                        $timestamp = $local.ToString('o')
                        return @{
                            Success    = $true
                            TimeZoneId = $TimeZoneId
                            Timestamp  = $timestamp
                        }
                    }

                    return @{
                        Success   = $true
                        Timestamp = (Get-Date).ToString('o')
                    }
                }
                catch {
                    return @{ Error = $_.Exception.Message }
                }
            } `
            -InputSchema @{
                TimeZoneId = 'Optional Windows time zone id, e.g. "Romance Standard Time".'
            } `
            -OutputDescription 'Returns @{ Success=[bool]; Timestamp=[string]; TimeZoneId?=[string] } or @{ Error=[string] }'

        return $tools
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
