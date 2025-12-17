
function Get-ElasticVersion { 
    [CmdletBinding()]
    param() 
    Invoke-ElasticRequest -Method GET -Path "/" -Query @{ pretty = 'true' } 
}