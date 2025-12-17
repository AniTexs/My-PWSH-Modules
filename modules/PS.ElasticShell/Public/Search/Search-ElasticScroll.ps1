function Search-ElasticScroll {
    [CmdletBinding()]
    param(
        [string]$Index,
        $QueryDsl,
        [string]$Kql,
        [int]$Size = 500,
        [string]$ScrollKeepAlive = '1m',
        [int]$MaxDocs
    )
    $idx = Ensure-Index -Index $Index

    $qPart = @{ match_all = @{} }
    if ($PSBoundParameters.ContainsKey('QueryDsl') -and $null -ne $QueryDsl) { $qPart = $QueryDsl }
    elseif ($Kql) { $qPart = @{ query_string = @{ query = $Kql } } }

    $body = @{
        size  = $Size
        query = $qPart
        sort  = @(@{ _doc = @{ order = 'asc' } })
    }

    $resp = Invoke-ElasticRequest -Method POST -Path "/$idx/_search" -Query @{ scroll = $ScrollKeepAlive } -Body $body
    $scrollId = $resp._scroll_id
    $collected = @()
    try {
        while ($true) {
            if ($resp.hits.hits.Count -eq 0) { break }
            $collected += $resp.hits.hits
            if ($PSBoundParameters.ContainsKey('MaxDocs') -and $MaxDocs -and $collected.Count -ge $MaxDocs) {
                $collected = $collected | Select-Object -First $MaxDocs
                break
            }
            $resp = Invoke-ElasticRequest -Method POST -Path "/_search/scroll" -Body @{ scroll = $ScrollKeepAlive; scroll_id = $scrollId }
            $scrollId = $resp._scroll_id
        }
    }
    finally {
        if ($scrollId) {
            try { Invoke-ElasticRequest -Method DELETE -Path "/_search/scroll" -Body @{ scroll_id = @($scrollId) } | Out-Null } catch {}
        }
    }
    return $collected
}
