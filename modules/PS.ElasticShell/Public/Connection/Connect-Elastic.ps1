
function Connect-Elastic {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Uri,
        [string]$ApiKey,
        [string]$Username,
        [Parameter(ValueFromPipeline)][SecureString]$Password,
        [string]$BearerToken,
        [string]$DefaultIndex,
        [int]$TimeoutSec = 100,
        [switch]$SkipCertificateCheck
    )
    $headers = @{ 'Accept' = 'application/json' }
    if ($ApiKey) {
        if ($ApiKey -like '*:*') {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($ApiKey)
            $token = [System.Convert]::ToBase64String($bytes)
            $headers['Authorization'] = "ApiKey $token"
        }
        else {
            $headers['Authorization'] = "ApiKey $ApiKey"
        }
    }
    elseif ($Username -and $Password) {
        $plain = "$($Username):" + ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)))
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($plain)
        $basic = [System.Convert]::ToBase64String($bytes)
        $headers['Authorization'] = "Basic $basic"
    }
    elseif ($BearerToken) {
        $headers['Authorization'] = "Bearer $BearerToken"
    }
    $Script:ElasticSession.BaseUri = $Uri
    $Script:ElasticSession.Headers = $headers
    $Script:ElasticSession.TimeoutSec = $TimeoutSec
    $Script:ElasticSession.DefaultIndex = $DefaultIndex
    $Script:ElasticSession.SkipCertificateCheck = [bool]$SkipCertificateCheck

    $pong = Invoke-ElasticRequest -Method GET -Path "/" -Query @{ pretty = 'true' }
    [pscustomobject]@{
        Name         = $pong.name
        ClusterName  = $pong.cluster_name
        ClusterUUID  = $pong.cluster_uuid
        Version      = $pong.version.number
        Tagline      = $pong.tagline
        BaseUri      = $Script:ElasticSession.BaseUri
        DefaultIndex = $Script:ElasticSession.DefaultIndex
    }
}