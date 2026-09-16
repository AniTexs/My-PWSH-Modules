function Build-Query (
    [Parameter(Mandatory)]
    [hashtable]
    $Query
) {
    <#
    .SYNOPSIS
    Builds a URL query string from key/value pairs.
    .DESCRIPTION
    Converts the provided hashtable into a URL encoded query string for API requests.
    .PARAMETER Query
    Hashtable of query string parameters.
    .EXAMPLE
    PS> Build-CapaOneQuery @{ filter = 'active'; page = 1 }
    ?filter=active&page=1
    #>
    $UrlQuery = @()
    $Query.GetEnumerator() | ForEach-Object {
        $Name = $_.Name
        if ($_.Value -is [System.Collections.IEnumerable] -and $_.Value -isnot [string]) {
            # Expand collections into repeated key=value pairs for List<T> query params
            foreach ($Item in $_.Value) {
                if (-not [String]::IsNullOrWhiteSpace($Item)) {
                    $UrlQuery += "$Name=$([uri]::EscapeDataString([string]$Item))"
                }
            }
        }
        elseif (-not [String]::IsNullOrWhiteSpace($_.Value)) {
            $UrlQuery += "$Name=$([uri]::EscapeDataString([string]$_.Value))"
        }
    }
    ("?"+($UrlQuery -join "&"))
}