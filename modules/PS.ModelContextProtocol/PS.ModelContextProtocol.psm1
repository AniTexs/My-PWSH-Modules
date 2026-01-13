#Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        Write-Verbose "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

#Export public functions
Export-ModuleMember -Function @(
    'Initialize-MCPServer'
    'Get-MCPTools'
    'Invoke-MCPTool'
    'Register-MCPSubmodule'
    'Get-MCPServerStatus'
    'New-MCPToolDefinition'
    'Start-MCPStdioServer'
    'New-MCPSubmodule'
)
