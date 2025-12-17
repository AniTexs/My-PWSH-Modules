function To-JsonBody {
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
    process {
        if ($null -eq $InputObject) { return $null }
        if ($InputObject -is [string]) { return $InputObject }
        return ($InputObject | ConvertTo-Json -Depth 100 -Compress)
    }
}
