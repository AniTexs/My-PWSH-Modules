function Start-MCPStdioServer {
    <#
        .SYNOPSIS
        Starts a minimal MCP-compatible JSON-RPC server over STDIO.

        .DESCRIPTION
        Runs an event loop that reads JSON-RPC messages from stdin and writes responses to stdout.
        Designed to be used with VS Code / Copilot MCP "type": "stdio".

        Supported methods:
        - initialize
        - tools/list
        - tools/call
        - notifications/initialized (no-op)

        .PARAMETER ModulePath
        The directory that contains PS.ModelContextProtocol.* submodules. Defaults to the parent folder of this module.

        .PARAMETER ForceInitialize
        Forces reinitialization of the tool registry on server start.

        .EXAMPLE
        Start-MCPStdioServer

        .NOTES
        Do not write non-protocol output to stdout. Logging is written to stderr.
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$ModulePath,

        [Parameter()]
        [switch]$ForceInitialize
    )

    function Write-MCPLog {
        param([string]$Message)
        try {
            [Console]::Error.WriteLine($Message)
        }
        catch {
            # ignore
        }
    }

    function Send-MCPMessage {
        param([Parameter(Mandatory)][object]$Message)
        $json = $Message | ConvertTo-Json -Depth 20 -Compress
        [Console]::Out.WriteLine($json)
        [Console]::Out.Flush()
    }

    function Read-MCPMessage {
        # Supports both newline-delimited JSON and Content-Length framing.
        while ($true) {
            $line = [Console]::In.ReadLine()
            if ($null -eq $line) {
                return $null
            }

            if ([string]::IsNullOrWhiteSpace($line)) {
                continue
            }

            if ($line -match '^Content-Length\s*:\s*(\d+)\s*$') {
                $length = [int]$Matches[1]

                # Read and discard remaining headers until blank line
                while ($true) {
                    $headerLine = [Console]::In.ReadLine()
                    if ($null -eq $headerLine -or [string]::IsNullOrEmpty($headerLine)) {
                        break
                    }
                }

                $buffer = New-Object char[] $length
                $read = 0
                while ($read -lt $length) {
                    $read += [Console]::In.Read($buffer, $read, $length - $read)
                }

                $payload = -join $buffer
                return ($payload | ConvertFrom-Json -ErrorAction Stop)
            }

            if ($line.TrimStart().StartsWith('{')) {
                return ($line | ConvertFrom-Json -ErrorAction Stop)
            }

            # Unknown line (likely noise) - ignore
        }
    }

    try {
        # Important: keep stdout clean for JSON-RPC; write diagnostics to stderr.
        $ProgressPreference = 'SilentlyContinue'
        $VerbosePreference = 'SilentlyContinue'
        $InformationPreference = 'SilentlyContinue'
        $WarningPreference = 'SilentlyContinue'

        if (-not $ModulePath) {
            $moduleBase = (Get-Module PS.ModelContextProtocol).ModuleBase
            $ModulePath = Split-Path -Parent $moduleBase
        }

        Initialize-MCPServer -Path $ModulePath -Force:$ForceInitialize | Out-Null

        # Diagnostics (stderr only)
        try {
            $status = Get-MCPServerStatus
            Write-MCPLog "MCP registry: Submodules=$($status.TotalSubmodules) Tools=$($status.TotalTools)"
            if ($status.TotalSubmodules -gt 0) {
                $subNames = ($status.Submodules | ForEach-Object { $_.Name }) -join ', '
                Write-MCPLog "MCP submodules: $subNames"
            }
        }
        catch {
            Write-MCPLog "MCP status unavailable: $($_.Exception.Message)"
        }

        $serverInfo = @{
            name    = 'PS.ModelContextProtocol'
            version = (Get-Module PS.ModelContextProtocol).Version.ToString()
        }

        Write-MCPLog "MCP STDIO server started. ModulePath=$ModulePath"

        while ($true) {
            $msg = Read-MCPMessage
            if ($null -eq $msg) {
                break
            }

            if (-not $msg.method) {
                continue
            }

            $method = [string]$msg.method
            $id = $msg.id

            switch ($method) {
                'initialize' {
                    $result = @{
                        protocolVersion = '2024-11-05'
                        serverInfo      = $serverInfo
                        capabilities    = @{
                            tools = @{
                                listChanged = $false
                            }
                        }
                    }

                    Send-MCPMessage @{ jsonrpc = '2.0'; id = $id; result = $result }
                }

                'notifications/initialized' {
                    # no-op
                }

                'tools/list' {
                    $tools = @()
                    # IMPORTANT: submodules also export Get-MCPTools, which can shadow the base command.
                    # Always call the base module version here.
                    foreach ($tool in (PS.ModelContextProtocol\Get-MCPTools)) {
                        $inputSchema = $null
                        if ($tool.PSObject.Properties.Name -contains 'InputJsonSchema' -and $tool.InputJsonSchema) {
                            $inputSchema = $tool.InputJsonSchema
                        }
                        else {
                            # Best-effort conversion from our descriptive hashtable.
                            $properties = @{}
                            foreach ($key in $tool.InputSchema.Keys) {
                                $properties[$key] = @{ type = 'string'; description = [string]$tool.InputSchema[$key] }
                            }
                            $inputSchema = @{ type = 'object'; properties = $properties }
                        }

                        $tools += @{
                            name        = $tool.Name
                            description = $tool.Description
                            inputSchema = $inputSchema
                        }
                    }

                    Send-MCPMessage @{ jsonrpc = '2.0'; id = $id; result = @{ tools = $tools } }
                }

                'tools/call' {
                    $toolName = $msg.params.name
                    $arguments = $msg.params.arguments

                    try {
                        $ht = @{}
                        if ($arguments) {
                            foreach ($p in $arguments.PSObject.Properties) {
                                $ht[$p.Name] = $p.Value
                            }
                        }

                        $data = Invoke-MCPTool -ToolName $toolName -Arguments $ht -ErrorAction Stop

                        $payload = @{
                            content = @(
                                @{ type = 'text'; text = ($data | ConvertTo-Json -Depth 20 -Compress) }
                            )
                        }

                        Send-MCPMessage @{ jsonrpc = '2.0'; id = $id; result = $payload }
                    }
                    catch {
                        $err = $_
                        Send-MCPMessage @{
                            jsonrpc = '2.0'
                            id      = $id
                            error   = @{
                                code    = -32000
                                message = $err.Exception.Message
                            }
                        }
                    }
                }

                default {
                    # Method not found
                    if ($null -ne $id) {
                        Send-MCPMessage @{
                            jsonrpc = '2.0'
                            id      = $id
                            error   = @{
                                code    = -32601
                                message = "Method not found: $method"
                            }
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-MCPLog "Fatal server error: $($_.Exception.Message)"
        throw
    }
    finally {
        Write-MCPLog 'MCP STDIO server exiting.'
    }
}
