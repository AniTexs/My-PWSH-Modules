
function Ensure-Index {
    param(
        [string]$Index
    )
    $idx = if ($PSBoundParameters.ContainsKey('Index') -and $Index) { $Index } elseif ($Script:ElasticSession.DefaultIndex) { $Script:ElasticSession.DefaultIndex } else { $null }
    if (-not $idx) { throw "No index specified. Provide -Index or set -DefaultIndex in Connect-Elastic." }
    return $idx
}