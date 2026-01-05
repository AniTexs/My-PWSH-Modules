function Build-TSQuery (
    [Parameter(Mandatory)]
    [hashtable]
    $Query
) {
    $UrlQuery = @()
    $Query.GetEnumerator() | ForEach-Object {
        $valueString = if ($null -eq $_.Value) { $null } else { [string]$_.Value }
        if (-not [String]::IsNullOrWhiteSpace($valueString)) {
            $UrlQuery += "$($_.Name)=$valueString"
        }

    }
    ("?" + ($UrlQuery -join "&"))
}