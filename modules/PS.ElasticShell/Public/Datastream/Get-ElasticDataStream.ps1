function Get-ElasticDataStream {
    [CmdletBinding()]
    param(
        [string]$Name,
        [ValidateSet("All","Open","Closed","hidden","none")]
        [string[]]$Include

    )
    $QueryParams = ""
    if ($Include) {
        $QueryParams = "?expand_wildcards=$(($Include -join ',').Trim())"
        $QueryParams.include = $Include -join ','
    }
    if ($PSBoundParameters.ContainsKey('Name') -and $Name) {
        $QueryParams['name'] = $Name
    }
    if ($PSBoundParameters.ContainsKey('Include')) {
        $QueryParams['include'] = $Include -join ','
    }
    if ($QueryParams.Count -gt 0) {
        $QueryString = '?' + ($QueryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join '&'
    } else {
        $QueryString = ''
    }
    if ($Name) {
        # If a specific datastream name is provided, query that datastream
        Write-Verbose "Retrieving data stream: $Name"
        # Use the Invoke-ElasticRequest function to make the API call
        # Ensure the function is defined in the module
        if ($QueryString) {
            $Name += $QueryString
        }
        Write-Verbose "Querying data stream with name: $Name"
        Invoke-ElasticRequest -Method GET -Path "/_data_stream/$Name"
    }
    else {
        Invoke-ElasticRequest -Method GET -Path "/_data_stream"
    }
}
