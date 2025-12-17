
function Test-ElasticConnection { 
    [CmdletBinding()]
    param() 
    Invoke-ElasticRequest -Method GET -Path "/_cluster/health" -Query @{ pretty = 'true' } 
}