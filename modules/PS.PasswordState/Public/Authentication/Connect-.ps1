function Connect- {
    [CmdletBinding()]
    param(
        [Alias('ApiUri')]
        [String]$BaseUrl,
        [String]$ApiKey,
        [int]$PasswordListId,
        [switch]$VerifySsl,
        [int]$TimeoutSec = 30
    )
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    $Uri = Build-PWSTUri -BaseUrl $BaseUrl -Endpoint "/passwordlists/$PasswordListId" -Query @{
        ExcludePassword = $True
    } -BypassContext
    $VerifySsl = $VerifySsl.IsPresent ? $VerifySsl : $true
    
    try {
        # Test the connection
        Write-Verbose "Testing connection to PasswordState API at $BaseUrl"
        Invoke-RestMethod -Uri $Uri -Method Get -Headers @{ "APIKey" = $ApiKey } -SkipCertificateCheck:(!$VerifySsl) -ConnectionTimeoutSeconds $TimeoutSec | Out-Null
        Write-Verbose "Connection successful."
        # Assign the context
        Write-Verbose "Setting context."
        $Params = @{
            BaseUrl        = $BaseUrl
            ApiKey         = $ApiKey
            PasswordListId = $PasswordListId
            VerifySsl      = $VerifySsl
            TimeoutSec     = $TimeoutSec
        }
        Set-PWSTContext @Params | Out-Null
        Write-Verbose "Context set."
        return $true
    }
    catch {
        throw "Failed to connect to PasswordState API. $_"
    }
}