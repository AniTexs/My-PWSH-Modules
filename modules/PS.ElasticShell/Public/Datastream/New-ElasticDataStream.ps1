function New-ElasticDataStream {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$Name,
        [switch]$IfNotExists
    )
    if ($IfNotExists) {
        try { $existing = Invoke-ElasticRequest -Method GET -Path "/_data_stream/$Name"; if ($existing) { return $existing } } catch {}
    }
    if ($PSCmdlet.ShouldProcess($Name, "Create data stream")) {
        Invoke-ElasticRequest -Method PUT -Path "/_data_stream/$Name"
    }
}