function Get-CleverCharger {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("Type2", "CCS", "CHAdeMO")]
        [string[]]
        $PlugType = ("Type2", "CCS", "CHAdeMO"),

        [Parameter()]
        [ValidateSet("Active", "Planned")]
        [string[]]
        $State = ("Active"),

        [string]
        $Search
    )

    $ApiUrl = "https://clever.dk/api/v2/chargers/locations"
    $ChargersResponse = Invoke-RestMethod -Uri $ApiUrl

    $LocationIds = $ChargersResponse.PSObject.Properties.Name

    $Chargers = $LocationIds | ForEach-Object {
        $ChargersResponse.$_
    }

    if ($PlugType) {
        $Chargers = $Chargers | Where-Object {
            @($_.plugTypes.plugType | Where-Object { $_ -in $PlugType }).Count -gt 0
        }
    }

    if ($State) {
        $Chargers = $Chargers | Where-Object {
            $_.state -in $State
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($Search)) {
        $Chargers = $Chargers |
            Where-Object { $_.name -match "$Search" -or $_.locationId -match "$Search" }
    }

    $Chargers
}