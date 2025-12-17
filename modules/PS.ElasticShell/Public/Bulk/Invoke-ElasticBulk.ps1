function Invoke-ElasticBulk {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$Index,
        [Parameter(Mandatory)]$Operations,
        [ValidateSet('true', 'wait_for')][string]$Refresh,
        [switch]$BypassValidation
    )
    $idx = if ($Index) { $Index } else { $Script:ElasticSession.DefaultIndex }

    # Build ndjson body
    $lines = New-Object System.Collections.Generic.List[string]
    if ($Operations -is [string]) {
        $lines.Add($Operations.TrimEnd("`n"))
    }
    else {
        for ($i = 0; $i -lt $Operations.Count; $i++) {
            $row = $Operations[$i]
            if ($row -is [string]) {
                $lines.Add($row.TrimEnd())
                continue
            }
            $json = ($row | ConvertTo-Json -Depth 100 -Compress)
            $lines.Add($json)
        }
    }
    $ndjson = ($lines -join "`n") + "`n"

    $query = @{}
    if ($idx) { $query['index'] = $idx }
    if ($PSBoundParameters.ContainsKey('Refresh') -and $null -ne $Refresh) { $query['refresh'] = $Refresh }

    $targetName = $idx; if (-not $targetName) { $targetName = '<per-row index>' }
    if ($PSCmdlet.ShouldProcess($targetName, "Bulk $($lines.Count) lines")) {
        $resp = Invoke-ElasticRequest -Method POST -Path "/_bulk" -Query $query -Body $ndjson -Raw
        $content = $resp.Content | ConvertFrom-Json
        if ($content.errors) {
            $errors = $content.items | Where-Object { $_.index.status -ge 400 -or $_.create.status -ge 400 -or $_.update.status -ge 400 -or $_.delete.status -ge 400 }
            if ($errors) {
                Write-Error ("Bulk completed with errors. First few errors:`n" + (($errors | Select-Object -First 5 | ConvertTo-Json -Depth 5)))
            }
        }
        return $content
    }
}
