function Get-UNCECountry {
    [CmdletBinding()]
    param (
        [Parameter()]
        [AllowEmptyString()]
        [string]
        $Search,

        [Parameter()]
        [switch]
        $Hashtable,

        [Parameter()]
        [Alias('WithSubdivions')]
        [switch]
        $WithSubdivisions,

        [Parameter()]
        [switch]
        $WithFunctions
    )

    if ($WithFunctions -and -not $WithSubdivisions) {
        throw "The -WithFunctions switch can only be used together with -WithSubdivisions."
    }

    $countries = (Invoke-UNCERequest -Path "unlocode-countries").'@graph' | ConvertFrom-UNCEObject

    if ($Search) {
        $countries = $countries | Where-Object {
            $_.Code -like "*$Search*" -or $_.Country -like "*$Search*"
        }
    }

    if ($WithSubdivisions) {
        $countries = $countries | ForEach-Object {
            if ($Hashtable) {
                $subdivisions = Get-UNCECountrySubdivision -CountryCode $_.Code -Hashtable
            }
            else {
                $subdivisions = Get-UNCECountrySubdivision -CountryCode $_.Code
            }

            if (-not $WithFunctions) {
                if ($Hashtable) {
                    $subdivisionResult = [ordered]@{}

                    foreach ($subdivisionCode in $subdivisions.Keys) {
                        $subdivision = $subdivisions[$subdivisionCode]
                        $subdivisionResult[$subdivisionCode] = [PSCustomObject]@{
                            Geo                = $subdivision.Geo
                            Name               = $subdivision.Name
                            Code               = $subdivision.Code
                            CountryCode        = $subdivision.CountryCode
                            CountrySubdivision = $subdivision.CountrySubdivision
                        }
                    }

                    $subdivisions = $subdivisionResult
                }
                else {
                    $subdivisions = $subdivisions | Select-Object -Property Geo, Name, Code, CountryCode, CountrySubdivision
                }
            }

            [PSCustomObject]@{
                Country      = $_.Country
                Code         = $_.Code
                Subdivisions = $subdivisions
            }
        }
    }

    if ($Hashtable) {
        $result = [ordered]@{}

        foreach ($country in $countries) {
            if ($WithSubdivisions) {
                $result[$country.Code] = [PSCustomObject]@{
                    Country      = $country.Country
                    Subdivisions = $country.Subdivisions
                }
            }
            else {
                $result[$country.Code] = $country.Country
            }
        }

        return $result
    }

    $countries
}