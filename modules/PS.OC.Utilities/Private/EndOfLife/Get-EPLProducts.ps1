function Get-EPLProducts {
    [CmdletBinding()]
    param ()
    $response = Invoke-RestMethod -Uri "https://endoflife.date/api/v1/products" -Method Get
    return $response.result
}