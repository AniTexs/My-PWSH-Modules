
function Set-ElasticDocument {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Index,
        [string]$Id,
        [Parameter(Mandatory, ValueFromPipeline)][Alias('Body')]$Document,
        [switch]$Create,
        [ValidateSet('true', 'wait_for')][string]$Refresh
    )
    begin { $idx = Ensure-Index -Index $Index }
    process {
        $path = if ($Id) { "/$idx/_doc/$Id" } else { "/$idx/_doc" }
        $query = @{}
        if ($Create) { $query['op_type'] = 'create' }
        if ($PSBoundParameters.ContainsKey('Refresh') -and $null -ne $Refresh) { $query['refresh'] = $Refresh }

        $method = 'POST'; if ($Id) { $method = 'PUT' }
        if ($PSCmdlet.ShouldProcess("$idx/$Id", "Index document")) {
            Invoke-ElasticRequest -Method $method -Path $path -Body $Document -Query $query
        }
    }
}