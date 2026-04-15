function Invoke-UNCERequest {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )
    if (-not $script:UNCECache) {
        $script:UNCECache = @{}
    }

    $Path = $Path.Trim('/')
    $url = "https://vocabulary.uncefact.org/$Path"
    if (-not $script:UNCECache[$Path]) {
        $data = Invoke-RestMethod -Uri $url -Headers @{
            Accept = "application/ld+json"
        }
        $script:UNCECache[$Path] = $data
    }
    $script:UNCECache[$Path]
}