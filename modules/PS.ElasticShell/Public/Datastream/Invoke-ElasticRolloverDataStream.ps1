function Invoke-ElasticRolloverDataStream {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$Name,
        [string]$NewBackingIndex # optional, e.g. ".ds-logs-bhj-prod-000123"
    )
    $body = $null
    if ($NewBackingIndex) { $body = @{ new_index = $NewBackingIndex } }
    if ($PSCmdlet.ShouldProcess($Name, "Rollover data stream")) {
        Invoke-ElasticRequest -Method POST -Path "/_data_stream/$Name/_rollover" -Body $body
    }
}
