# PS.UN.LOCODE

PowerShell wrapper for the UN/CEFACT vocabulary endpoints used for country, subdivision, and location-function metadata.

## Overview

`PS.UN.LOCODE` provides a simple way to query UN/CEFACT location code data from PowerShell using structured objects.

The module currently exposes three public commands:

- `Get-UNCECountry`
- `Get-UNCECountrySubdivision`
- `Get-UNCEFunction`

Data is retrieved from:

- `https://vocabulary.uncefact.org/unlocode-countries`
- `https://vocabulary.uncefact.org/unlocode-functions`
- `https://vocabulary.uncefact.org/unlocode`

## Requirements

- PowerShell 7+ recommended

## Example



## Installation


```powershell
Install-Module PS.UN.LOCODE
```

## Quick Start

Get all countries:

```powershell
Get-UNCECountry
```

Search for a country by code or name:

```powershell
Get-UNCECountry -Search "Denmark"
Get-UNCECountry -Search "DK"
```

Get country with subdivisions[^subdivisions]:

[^subdivisions]: Subdivisions are more or less the cities.

```powershell
Get-UNCECountry -Search "Denmark" -WithSubdivisions
```

Get country with subdivisions and location functions[^functions]:

[^functions]: Functions are the infrastructure which the subdivision[^subdivisions] has

```powershell
Get-UNCECountry -Search "Denmark" -WithSubdivisions -WithFunctions
```

Get all functions[^functions]:

```powershell
Get-UNCEFunction
```

Get one specific function[^functions] code:

```powershell
Get-UNCEFunction -Function 1
```

Get subdivisions for a country:

```powershell
Get-UNCECountrySubdivision -CountryCode DK
```

Filter subdivisions[^subdivisions] by function[^functions] codes:

```powershell
Get-UNCECountrySubdivision -CountryCode DK -FunctionCode @('1','3')
```

## Command Reference

### Get-UNCECountry

Returns country information from UN/CEFACT.

Parameters:

- `-Search [string]`: Filters by country code or country name.
- `-Hashtable [switch]`: Returns an ordered dictionary keyed by country code.
- `-WithSubdivisions [switch]`: Includes subdivision data for each country.
- `-WithFunctions [switch]`: Includes subdivision function details. Must be used with `-WithSubdivisions`.

Examples:

```powershell
# Default object output
Get-UNCECountry

# Hashtable output
Get-UNCECountry -Hashtable

# Country with subdivisions (and function details)
Get-UNCECountry -Search "Denmark" -WithSubdivisions -WithFunctions
```

Output shape:

- Default: objects with `Country`, `Code`
- With subdivisions: objects with `Country`, `Code`, `Subdivisions`
- Hashtable mode: ordered dictionary keyed by country code

### Get-UNCECountrySubdivision

Returns subdivisions for a specific two-letter country code.

Parameters:

- `-CountryCode [string]` (mandatory): Two-character country code (for example `DK`, `US`, `DE`).
- `-FunctionCode [char[]]`: Filters subdivisions to those that support one or more function codes.
- `-Hashtable [switch]`: Returns an ordered dictionary keyed by subdivision code.

Examples:

```powershell
Get-UNCECountrySubdivision -CountryCode DK
Get-UNCECountrySubdivision -CountryCode DK -Hashtable
Get-UNCECountrySubdivision -CountryCode DK -FunctionCode @('1','2','3')
```

Output shape:

- `Geo` (placeholder latitude/longitude)
- `Name` (language-tagged names)
- `Code`
- `CountryCode`
- `CountrySubdivision`
- `Functions`

### Get-UNCEFunction

Returns available UN/CEFACT function codes.

Parameters:

- `-Function [string]`: Optional function code filter.

Examples:

```powershell
Get-UNCEFunction
Get-UNCEFunction -Function 1
```

Output shape:

- `Function`
- `Code`

## Notes

- Requests are cached in-memory per PowerShell session by path to reduce repeated web calls.
- `-WithFunctions` on `Get-UNCECountry` throws if `-WithSubdivisions` is not also provided.
- `-FunctionCode` on `Get-UNCECountrySubdivision` validates against available values from `Get-UNCEFunction`.

## Testing

Run Pester tests from the module root:

```powershell
Invoke-Pester -Path .\Tests\PS.UN.LOCODE.Tests.ps1
```

## License

No explicit license file is currently included in this module folder.
