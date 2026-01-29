function Build-PWSTUri {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$BaseUrl,
        [Parameter(Mandatory)][string]$Endpoint,
        [hashtable]$Query,
        [hashtable]$Context,
        [switch]$BypassContext
    )
    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    Write-Verbose "PWSTURI:: Building PWST URI for Endpoint: $Endpoint"
    if (-not $BypassContext.IsPresent) {
        Write-Verbose "PWSTURI:: Applying context replacements."
        if ($Context) {
            $ctx = $Context
        } else {
            $ctx = Get-Context
        }
        if (-not $Ctx) {
            throw "No context set. Connect to a PasswordState instance first."
        }
        # Replace common parameters in $Path
        $Replacements = @{
            '<PasswordListID>' = $Ctx.PasswordListId
            '<APIKey>'         = $Ctx.ApiKey
            '<BaseUrl>'        = $BaseUrl
            '<TimeoutSec>'     = $Ctx.TimeoutSec
            '<VerifySsl>'      = $Ctx.VerifySsl
            '{PasswordListID}' = $Ctx.PasswordListId
            '{APIKey}'         = $Ctx.ApiKey
            '{BaseUrl}'        = $BaseUrl
            '{TimeoutSec}'     = $Ctx.TimeoutSec
            '{VerifySsl}'      = $Ctx.VerifySsl
        }
        foreach ($k in $Replacements.Keys) {
            if ($Endpoint -match [regex]::Escape($k)) {
                Write-Verbose "PWSTURI:: Replacing '$k' with '$($Replacements[$k])'"
                $Endpoint = $Endpoint -replace [regex]::Escape($k), [string]$Replacements[$k]
            }
        }
    }else{
        Write-Verbose "PWSTURI:: Bypassing context replacements."
    }
    

    # Make sure the $BaseUrl has the /api
    Write-Verbose "PWSTURI:: Ensuring BaseUrl ends with /api"
    if ($BaseUrl.EndsWith('/')) { $BaseUrl = $BaseUrl.TrimEnd('/') }
    if (-not $BaseUrl.EndsWith('/api')) {$BaseUrl += '/api'}


    Write-Verbose "PWSTURI:: Normalizing Endpoint format"
    if (-not $Endpoint.StartsWith('/')) { $Endpoint = "/$Endpoint" }
    if ($Endpoint.StartsWith('/api')) {$Endpoint = $Endpoint.Substring(4)}
    if ($Endpoint.EndsWith('/')) { $Endpoint = $Endpoint.TrimEnd('/') }
    
    
    $uri = $BaseUrl + $Endpoint
    if ($Query) {
        $q = Build-QueryFromParams -Query $Query
        $uri += $q
    }
    Write-Verbose "PWSTURI:: Built URI: $uri"
    return $uri
}