function Update-ElasticDocument {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Index,
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)]$Doc,
        $Upsert,
        [ValidateSet('true', 'wait_for')][string]$Refresh
    )
    $idx = Ensure-Index -Index $Index
    $body = @{ doc = $Doc }
    if ($PSBoundParameters.ContainsKey('Upsert')) { $body['doc_as_upsert'] = $true; $body['upsert'] = $Upsert }
    $query = @{}
    if ($PSBoundParameters.ContainsKey('Refresh') -and $null -ne $Refresh) { $query['refresh'] = $Refresh }

    if ($PSCmdlet.ShouldProcess("$idx/$Id", "Update document")) {
        Invoke-ElasticRequest -Method POST -Path "/$idx/_update/$Id" -Body $body -Query $query
    }
}
