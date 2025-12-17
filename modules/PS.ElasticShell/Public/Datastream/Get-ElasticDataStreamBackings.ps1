function Get-ElasticDataStreamBackings {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Name)
    $resp = Invoke-ElasticRequest -Method GET -Path "/_data_stream/$Name"
    $ds = $resp.data_streams | Select-Object -First 1
    if (-not $ds) { return @() }
    return $ds.indices | ForEach-Object {
        [pscustomobject]@{
            IndexName = $_.index_name
            IndexUUID = $_.index_uuid
        }
    }
}
