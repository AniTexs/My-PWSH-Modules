function Clear-ElasticIndex {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Index
    )
    $idx = if ($Index) { $Index } else { $Script:ElasticSession.DefaultIndex }
    $idx = Ensure-Index -Index $idx
    if ($PSCmdlet.ShouldProcess($idx, "Empty index (Will delete all documents and mappings, only settings will be preserved)")) {
        $ElasticIndex = Get-ElasticIndex -Index $idx | select -ExpandProperty $idx
        # Remove the index itself
        # This will delete the index and all its documents
        Remove-ElasticIndex -Index $idx | Out-Null
        # Recreate the index with the same settings and mappings
        if (-not $ElasticIndex) {
            throw "Index '$idx' does not exist or could not be retrieved."
        }
        $Settings = $ElasticIndex.settings.index | select -ExcludeProperty creation_date, uuid, version, provided_name
        #[hashtable]$Mappings = $ElasticIndex.mappings.properties
        New-ElasticIndex -Index $idx -Settings $Settings -IfNotExists | Out-Null
        Write-Host "Index '$idx' cleared and recreated."
    }
}