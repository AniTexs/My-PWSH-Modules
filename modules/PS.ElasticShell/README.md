# ElasticShell

A lightweight PowerShell module for Elasticsearch (7.x/8.x).

## Install (manual)

```powershell
$mod = Join-Path $HOME "Documents\PowerShell\Modules\ElasticShell\0.1.0"
New-Item -ItemType Directory -Force -Path $mod | Out-Null
Copy-Item .\ElasticShell.psm1,.\ElasticShell.psd1 -Destination $mod
Import-Module ElasticShell -Force
```

## Quickstart

```powershell
# Connect (API Key or Basic)
Connect-Elastic -Uri https://localhost:9200 -Username elastic -Password (Read-Host -AsSecureString)

# Create index with mapping
New-ElasticIndex -Index logs-app -Settings @{ number_of_shards = 1 } -Mappings @{ properties = @{ timestamp = @{ type='date' }; level=@{type='keyword'}; message=@{type='text'} } }

# Index a doc
Set-ElasticDocument -Index logs-app -Document @{ timestamp=(Get-Date); level='info'; message='hello' } -Refresh wait_for

# Get by id
Get-ElasticDocument -Index logs-app -Id "<id>"

# Search (KQL/Lucene)
Search-Elastic -Index logs-app -Kql "level:info" -Size 5 -Sort "timestamp:desc"

# Bulk from objects
1..5 | ForEach-Object { [pscustomobject]@{ id=$_; message="hi $_"; ts=(Get-Date) } } |
  Add-ElasticBulkFromObjects -Index logs-app -IdProperty id -Refresh wait_for

# Scroll for large result sets
Search-ElasticScroll -Index logs-app -Kql '*' -Size 1000 -ScrollKeepAlive '2m' -MaxDocs 10000
```

## Notes

- `-SkipCertificateCheck` on `Connect-Elastic` is handy for dev clusters with self-signed certs. Avoid in production.
- Module targets PowerShell 5.1+, utilizes `Invoke-RestMethod`. On PS7+ it takes advantage of `-SkipCertificateCheck` when requested.
- Endpoints used are compatible with ES 7/8 (`_doc`, `_search`, `_bulk`, `_scroll`).

MIT License.
