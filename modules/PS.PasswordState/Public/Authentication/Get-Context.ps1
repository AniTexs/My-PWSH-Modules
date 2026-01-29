function Get-Context {
    <#if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }#>
    if (-not $Script:PWST_Context) {
        throw "No context set. Connect to a PasswordState instance first."
    }
    return $Script:PWST_Context
}