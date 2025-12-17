function Search-Elastic {
    [CmdletBinding()]
    param(
        [string]$Index,
        $QueryDsl,
        [string]$Kql,
        [int]$Size = 10,
        [int]$From = 0,
        $Sort,
        $Source,
        $TrackTotalHits = $true
    )
    $idx = Ensure-Index -Index $Index

    $body = @{
        size             = $Size
        from             = $From
        track_total_hits = $TrackTotalHits
    }

    if ($PSBoundParameters.ContainsKey('Source')) { $body['_source'] = $Source }

    if ($PSBoundParameters.ContainsKey('QueryDsl') -and $null -ne $QueryDsl) {
        $body['query'] = $QueryDsl
    }
    elseif ($Kql) {
        $body['query'] = @{ query_string = @{ query = $Kql } }
    }
    else {
        $body['query'] = @{ match_all = @{} }
    }

    if ($Sort) {
        if ($Sort -is [System.Array]) {
            $body['sort'] = @()
            foreach ($s in $Sort) {
                if ($s -is [string] -and $s -match '^(?<f>[^:]+):(?<d>asc|desc)$') {
                    $body['sort'] += @{ ($matches.f) = @{ order = $matches.d } }
                }
                else {
                    $body['sort'] += $s
                }
            }
        }
        else {
            $body['sort'] = $Sort
        }
    }

    Invoke-ElasticRequest -Method POST -Path "/$idx/_search" -Body $body
}
