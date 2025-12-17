
function Invoke-ElasticRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [string]$Method,
        [Parameter(Mandatory)][string]$Path,
        [hashtable]$Query,
        $Body,
        [switch]$Raw
    )
    $uri = Resolve-ElasticUri -Path $Path -Query $Query

    $irParams = @{
        Method      = $Method
        Uri         = $uri
        Headers     = $Script:ElasticSession.Headers
        ContentType = 'application/json'
        TimeoutSec  = $Script:ElasticSession.TimeoutSec
        ErrorAction = 'Stop'
    }

    if ($PSBoundParameters.ContainsKey('Body') -and $null -ne $Body) {
        $irParams['Body'] = (To-JsonBody $Body)
    }

    # PowerShell 7+ supports -SkipCertificateCheck
    if ($Script:ElasticSession.SkipCertificateCheck) {
        $skipParam = (Get-Command Invoke-RestMethod).Parameters.Keys -contains 'SkipCertificateCheck'
        if ($skipParam) {
            $irParams['SkipCertificateCheck'] = $true
        }
        else {
            # Legacy workaround for Windows PowerShell 5.1 (global effect!)
            if (-not $script:__origCallback) {
                $script:__origCallback = [System.Net.ServicePointManager]::ServerCertificateValidationCallback
            }
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        }
    }

    try {
        if ($Raw) {
            return Invoke-WebRequest @irParams
        }
        else {
            return Invoke-RestMethod @irParams
        }
    }
    catch {
        $msg = $_.Exception.Message
        try {
            # Try to surface Elasticsearch error payload
            if ($_.ErrorDetails.Message) {
                $err = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction Ignore
                if ($err) {
                    $reason = $err.error.reason
                    $type = $err.error.type
                    if ($reason) { $msg = "$($type): $reason" }
                }
            }
        }
        catch {}
        throw [System.Exception]::new("Elasticsearch request failed: $($Method) $($Path) -> $msg", $_.Exception)
    }
    finally {
        if ($Script:ElasticSession.SkipCertificateCheck -and -not ((Get-Command Invoke-RestMethod).Parameters.Keys -contains 'SkipCertificateCheck')) {
            # restore original callback on Windows PowerShell
            if ($script:__origCallback) {
                [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $script:__origCallback
            }
        }
    }
}