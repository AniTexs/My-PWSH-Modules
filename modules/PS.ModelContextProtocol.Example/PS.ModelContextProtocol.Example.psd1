@{
    RootModule          = 'PS.ModelContextProtocol.Example.psm1'
    ModuleVersion       = '0.1.0'
    GUID                = '2d82f118-94e4-43c3-c94f-bc2df193c666'
    Author              = 'Example Author'
    CompanyName         = 'Example Company'
    Description         = 'Example MCP submodule demonstrating tool implementation'
    PowerShellVersion   = '7.0'
    RequiredModules     = @('PS.ModelContextProtocol')
    FunctionsToExport   = @('Get-MCPTools')
}
