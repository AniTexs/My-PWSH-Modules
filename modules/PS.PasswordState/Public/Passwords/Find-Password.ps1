function Find-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$SearchTerm,
        [Switch]$PreventAuditing
    )
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    $Path = "/searchpasswords/<PasswordListID>"
    $Query = @{
        Search = $SearchTerm
        PreventAuditing = $PreventAuditing.IsPresent
        ExcludePassword = $true
    }
    if([String]::IsNullOrWhiteSpace($SearchTerm)){
        $Query.QueryAll = $true
    }
    try {
        $Response = Invoke-PWSTRequest -Method Get -Path $Path -Query $Query -ErrorAction Stop
        if($response){
            return $Response
        }
    }
    catch {
        return $null
    }
    return 
}