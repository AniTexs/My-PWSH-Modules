function Get-CleverChargerDetail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [guid]
        $LocationId
    )
    process {
        $Uri = "https://clever.dk/api/v2/chargers/location/$($LocationId)"
        Invoke-RestMethod -Uri $Uri
    }
}