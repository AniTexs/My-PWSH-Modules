function New-MCPToolDefinition {
    <#
        .SYNOPSIS
        Creates a properly formatted MCP tool definition object.

        .DESCRIPTION
        Generates a tool definition that can be returned by a submodule's Get-MCPTools function.
        Ensures all required properties are present for proper tool registration and execution.

        .PARAMETER Name
        The unique name of the tool. Used to invoke the tool via Invoke-MCPTool.

        .PARAMETER Description
        A detailed description of what the tool does.

        .PARAMETER Handler
        A scriptblock or function name that executes the tool. Must accept arguments matching the InputSchema.

        .PARAMETER InputSchema
        A hashtable describing the tool's input parameters. Keys are parameter names, values describe the parameter.
        Example: @{ Identity = 'The user identity (username or email)'; Filter = 'LDAP filter string' }

        .PARAMETER SubmoduleName
        Optional. The name of the submodule that provides this tool. Auto-populated if not specified.

        .PARAMETER OutputDescription
        Optional. Description of the tool's output format.

        .EXAMPLE
        $toolDef = New-MCPToolDefinition `
            -Name 'Get-ADUser-Info' `
            -Description 'Retrieves Active Directory user information' `
            -Handler { param($Identity) Get-ADUser -Identity $Identity } `
            -InputSchema @{ Identity = 'User identity (username, email, or SID)' } `
            -OutputDescription 'Returns PSObject with user properties'

        .NOTES
        The Handler scriptblock or function receives arguments as a hashtable that can be splatted.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateScript({ $_ -is [scriptblock] -or $_ -is [string] })]
        $Handler,

        [Parameter(Mandatory)]
        [hashtable]$InputSchema,

        [Parameter()]
        [string]$SubmoduleName,

        [Parameter()]
        [string]$OutputDescription
    )

    try {
        # If SubmoduleName not provided, try to get it from the caller
        if (-not $SubmoduleName) {
            $stack = Get-PSCallStack
            $candidateFrame = $stack | Where-Object {
                $_.ScriptName -and ($_.ScriptName -match '\\PS\.ModelContextProtocol\.')
            } | Select-Object -First 1

            if ($candidateFrame -and $candidateFrame.ScriptName) {
                $pathParts = $candidateFrame.ScriptName -split '\\'
                $candidateModuleFolder = $pathParts | Where-Object { $_ -match '^PS\.ModelContextProtocol\..+' } | Select-Object -First 1
                if ($candidateModuleFolder) {
                    $SubmoduleName = $candidateModuleFolder
                }
            }
        }

        $toolDef = @{
            Name                = $Name
            Description         = $Description
            Handler             = $Handler
            InputSchema         = $InputSchema
            OutputDescription   = $OutputDescription
            SubmoduleName       = $SubmoduleName
            CreatedAt          = Get-Date
        }

        return [PSCustomObject]$toolDef
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
