function Test-MCPToolDefinition {
    <#
        .SYNOPSIS
        Validates an MCP tool definition for completeness and correctness.

        .DESCRIPTION
        Checks that a tool definition has all required properties and that they are valid.
        Useful for submodule authors to validate their tools before exporting them.

        .PARAMETER ToolDefinition
        The tool definition object to validate.

        .EXAMPLE
        $isValid = Test-MCPToolDefinition -ToolDefinition $toolDef

        .NOTES
        Returns $true if the definition is valid, $false otherwise.
        Writes warnings for any validation issues found.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [object]$ToolDefinition
    )

    try {
        $isValid = $true

        # Check required properties
        $requiredProperties = @('Name', 'Description', 'Handler', 'InputSchema')
        foreach ($property in $requiredProperties) {
            if (-not $ToolDefinition.$property) {
                Write-Warning "Tool definition missing required property: $property"
                $isValid = $false
            }
        }

        # Validate Name
        if ($ToolDefinition.Name -and -not ($ToolDefinition.Name -match '^[a-zA-Z0-9_-]+$')) {
            Write-Warning "Tool name '$($ToolDefinition.Name)' contains invalid characters. Use alphanumeric, dash, or underscore."
            $isValid = $false
        }

        # Validate Handler
        if ($ToolDefinition.Handler) {
            if (-not ($ToolDefinition.Handler -is [scriptblock] -or $ToolDefinition.Handler -is [string])) {
                Write-Warning "Tool handler must be a scriptblock or function name string"
                $isValid = $false
            }
        }

        # Validate InputSchema
        if ($ToolDefinition.InputSchema -and -not ($ToolDefinition.InputSchema -is [hashtable])) {
            Write-Warning "InputSchema must be a hashtable"
            $isValid = $false
        }

        return $isValid
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
