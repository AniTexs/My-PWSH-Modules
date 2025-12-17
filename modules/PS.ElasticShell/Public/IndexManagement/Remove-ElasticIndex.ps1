
function Remove-ElasticIndex {
    [CmdletBinding(SupportsShouldProcess)]
    param([Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Index)
    if ($PSCmdlet.ShouldProcess($Index, "Delete index")) {
        Invoke-ElasticRequest -Method DELETE -Path "/$Index"
    }
}