@{
    RootModule        = 'PS.ElasticShell.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '8a6c7f25-7a69-4b6b-9148-5f5e3a3c1f95'
    Author            = 'Nicolai Jacobsen'
    CompanyName       = ''
    Copyright         = '(c) 2025. MIT License.'
    Description       = 'PowerShell module for interacting with Elasticsearch: connect, index, search, bulk, and admin convenience functions.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('*')
    <#FunctionsToExport = @(
        'Connect-Elastic',
        'Disconnect-Elastic',
        'Get-ElasticVersion',
        'Test-ElasticConnection',
        'New-ElasticIndex',
        'Get-ElasticIndex',
        'Remove-ElasticIndex',
        'Set-ElasticDocument',
        'Get-ElasticDocument',
        'Remove-ElasticDocument',
        'Update-ElasticDocument',
        'Search-Elastic',
        'Search-ElasticScroll',
        'Invoke-ElasticBulk',
        'Add-ElasticBulkFromObjects',
        'Clear-ElasticIndex'
    )#>
    CmdletsToExport   = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags = @('Elasticsearch','Search','Observability','Logging','DevOps','REST')
            ProjectUri = ''
            LicenseUri = 'https://opensource.org/license/mit/'
            ReleaseNotes = 'Initial release'
        }
    }
}

