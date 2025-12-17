function Remove-ElasticDocument {
    [CmdletBinding(SupportsShouldProcess)]
    param([string]$Index, [Parameter(Mandatory)][string]$Id, [ValidateSet('true', 'wait_for')][string]$Refresh)
    $idx = Ensure-Index -Index $Index
    $query = @{}
    if ($PSBoundParameters.ContainsKey('Refresh') -and $null -ne $Refresh) { $query['refresh'] = $Refresh }
    if ($PSCmdlet.ShouldProcess("$idx/$Id", "Delete document")) {
        Invoke-ElasticRequest -Method DELETE -Path "/$idx/_doc/$Id" -Query $query
    }
}
