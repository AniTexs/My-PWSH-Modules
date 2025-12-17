function Remove-ElasticDataStream {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][string]$Name)
    if ($PSCmdlet.ShouldProcess($Name, "Delete data stream")) {
        Invoke-ElasticRequest -Method DELETE -Path "/_data_stream/$Name"
    }
}
