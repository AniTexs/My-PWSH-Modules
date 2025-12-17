
function Disconnect-Elastic {
    [CmdletBinding(SupportsShouldProcess = $false)]
    param()
    $Script:ElasticSession = [ordered]@{
        BaseUri              = $null
        Headers              = @{}
        TimeoutSec           = 100
        DefaultIndex         = $null
        SkipCertificateCheck = $false
    }
    $true
}