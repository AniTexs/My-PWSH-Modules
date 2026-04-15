# Changelog

All notable changes to this module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-14

### Added

- Initial module scaffold and manifest for `PS.UN.LOCODE`.
- Public commands:
	- `Get-UNCECountry`
	- `Get-UNCECountrySubdivision`
	- `Get-UNCEFunction`
- Private helper functions for data retrieval and object conversion:
	- `Invoke-UNCERequest`
	- `Get-UNCEData`
	- `ConvertFrom-UNCEObject`
	- `ConvertTo-CountryObject`
	- `ConvertTo-SubdivisionObject`
- In-session response caching for UN/CEFACT endpoint requests.
- Pester test suite covering core command behaviors and validation scenarios.
- Initial README documentation with usage examples.
