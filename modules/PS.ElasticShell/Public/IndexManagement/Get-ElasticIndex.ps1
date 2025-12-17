
function Get-ElasticIndex { 
    [CmdletBinding()]
    param([string]$Index) 
    if ($Index) { 
        Invoke-ElasticRequest -Method GET -Path "/$Index" 
    } else { 
        Invoke-ElasticRequest -Method GET -Path "/_cat/indices" -Query @{ format = 'json' } 
    } 
}