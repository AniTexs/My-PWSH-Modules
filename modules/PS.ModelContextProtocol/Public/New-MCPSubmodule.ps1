function New-MCPSubmodule {
    <#
    .SYNOPSIS
    Creates a new Model Context Protocol (MCP) submodule object.

    .DESCRIPTION
    The New-MCPSubmodule function creates a new MCP submodule object with the specified properties.
    This object can be used to define submodules within a larger MCP model context.

    .PARAMETER Name
    The name of the submodule.

    .PARAMETER Version
    The version of the submodule.

    .PARAMETER Description
    A brief description of the submodule.

    .EXAMPLE
    $submodule = New-MCPSubmodule -Name "UserManagement" -Version "1.0.0" -Description "Handles user authentication and authorization."

    This example creates a new MCP submodule named "UserManagement" with version "1.0.0" and a description.

    .OUTPUTS
    PSCustomObject representing the MCP submodule.

    .NOTES
    This function is part of the PS.ModelContextProtocol module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Version,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        $Author
    )

    $RootModuleName = (Get-Module -Name PS.ModelContextProtocol).Name
    $ModuleName = $Name
    # Check if the $Name starts with the RootModuleName
    if (-not $Name.StartsWith("$RootModuleName.")) {
        $ModuleName = "$RootModuleName.$Name"
    }

    $PSDObject = [PSCustomObject]@{
        Name        = $ModuleName
        Version     = $Version
        Description = $Description
        Path        = $Path
        Author      = $Author
        CreatedAt   = Get-Date
    }

    # Test if the Path is valid
    if (-not $Path -or [string]::IsNullOrWhiteSpace($Path)) {
        throw "Path parameter is required and cannot be null or empty."
    }

    # Create the Folder for the Submodule if it doesn't exist
    $ModulePath = Join-Path -Path $Path -ChildPath $ModuleName
    if (-not (Test-Path -Path $ModulePath -PathType Container)) {
        New-Item -Path $ModulePath -ItemType Directory -Force | Out-Null
    }

    #
    # Create Module Structure
    #

    # Create Public Folder
    $PublicPath = Join-Path -Path $ModulePath -ChildPath 'Public'
    if (-not (Test-Path -Path $PublicPath -PathType Container)) {
        New-Item -Path $PublicPath -ItemType Directory -Force | Out-Null
    }
    # Create Private Folder
    $PrivatePath = Join-Path -Path $ModulePath -ChildPath 'Private'
    if (-not (Test-Path -Path $PrivatePath -PathType Container)) {
        New-Item -Path $PrivatePath -ItemType Directory -Force | Out-Null
    }
    # Create Tools Folder
    $ToolsPath = Join-Path -Path $ModulePath -ChildPath 'Tools'
    if (-not (Test-Path -Path $ToolsPath -PathType Container)) {
        New-Item -Path $ToolsPath -ItemType Directory -Force | Out-Null
    }

    # Create Demo Tool File
    $DemoToolPath = Join-Path -Path $ToolsPath -ChildPath 'DemoTool.ps1'
    $ToolNamePrefix = ($Name -replace '\.', '_').Replace(' ', '_').ToLower()
    $DemoToolContent = @'
New-MCPToolDefinition `
-Name "ps_mcp_{moduleNameDef}_example" `
-Description "Example tool for the {ModuleName} submodule." `
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
    Text = "The text input for the example tool. Required."
} `
-OutputDescription "Returns @{ Success=[bool]; Text=[string] | Error=[string] }"
'@
    $DemoToolContent = $DemoToolContent.Replace('{moduleNameDef}', $ToolNamePrefix).Replace('{ModuleName}', $ModuleName)
    Set-Content -Path $DemoToolPath -Value $DemoToolContent -Force
    # Create Module File
    $ModuleFilePath = Join-Path -Path $ModulePath -ChildPath ($ModuleName + '.psm1')
    $ModuleFileContent = @'
#Get public and private function definition files
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
foreach($import in @($Public + $Private)) {
    Try {
        Write-Verbose "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}

# Export only Get-MCPTools function
Export-ModuleMember -Function 'Get-MCPTools'
'@
    Set-Content -Path $ModuleFilePath -Value $ModuleFileContent -Force

    # Create the Get-MCPTools Function File
    $GetMCPToolsPath = Join-Path -Path $PublicPath -ChildPath 'Get-MCPTools.ps1'
    $GetMCPToolsContent = @'
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

        $ToolDefinitionFiles= Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\Tools\*.ps1') -ErrorAction SilentlyContinue
        foreach ($toolFile in $ToolDefinitionFiles) {
            $Tools += . $toolFile.FullName
        }
        return $tools
    }
    catch {
        throw "Error in Get-MCPTools: $($_.Exception.Message)"
    }
}
'@
    Set-Content -Path $GetMCPToolsPath -Value $GetMCPToolsContent -Force


    # Create Manifest File
    $ManifestPath = Join-Path -Path $ModulePath -ChildPath ($ModuleName + '.psd1')
    $ManifestContent = @{
        RootModule        = "$ModuleName.psm1"
        ModuleVersion     = $Version
        GUID              = [guid]::NewGuid().ToString()
        Author            = $Author
        Description       = $Description
        CmdletsToExport   = @()
        FunctionsToExport = @('Get-MCPTools')
        VariablesToExport = @()
        AliasesToExport   = @()
    }
    New-ModuleManifest -Path $ManifestPath @ManifestContent | Out-Null
    #$ManifestContent | Export-PowerShellDataFile -Path $ManifestPath -Force

    



}