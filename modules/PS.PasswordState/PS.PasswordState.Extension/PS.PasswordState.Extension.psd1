@{
    ModuleVersion = '1.0'
    RootModule = '.\PS.PasswordState.Extension.psm1'
    FunctionsToExport = @('Set-Secret','Get-Secret','Remove-Secret','Get-SecretInfo','Test-SecretVault','Set-SecretInfo')
}