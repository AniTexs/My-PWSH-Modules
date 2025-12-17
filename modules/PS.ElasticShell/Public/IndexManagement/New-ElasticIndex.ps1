
function New-ElasticIndex {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Index,
        $Settings,
        $Mappings,
        [switch]$IfNotExists
    )
    if ($IfNotExists) {
        try { $existing = Invoke-ElasticRequest -Method GET -Path "/$Index"; if ($existing) { return $existing } } catch {}
    }
    $body = @{}
    if ($Settings) { $body.settings = $Settings }
    if ($Mappings) { $body.mappings = $Mappings }
    if ($PSCmdlet.ShouldProcess($Index, "Create index")) {
        Invoke-ElasticRequest -Method PUT -Path "/$Index" -Body $body
    }
}