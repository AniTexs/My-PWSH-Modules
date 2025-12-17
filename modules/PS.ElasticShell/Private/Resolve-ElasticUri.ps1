function Resolve-ElasticUri {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [hashtable]$Query
    )
    if (-not $Script:ElasticSession.BaseUri) {
        throw "Not connected. Run Connect-Elastic first."
    }
    $base = $Script:ElasticSession.BaseUri.TrimEnd('/')
    $path = if ($Path.StartsWith('/')) { $Path } else { "/$Path" }
    if ($Query -and $Query.Count -gt 0) {
        $qs = ($Query.GetEnumerator() | ForEach-Object {
                if ($null -eq $_.Value -or [string]::IsNullOrWhiteSpace([string]$_.Value)) { return $null }
                [System.Uri]::EscapeDataString([string]$_.Key) + '=' + [System.Uri]::EscapeDataString([string]$_.Value)
            } | Where-Object { $_ }) -join '&'
        if ($qs) { "$base$path`?$qs" } else { "$base$path" }
    }
    else {
        "$base$path"
    }
}