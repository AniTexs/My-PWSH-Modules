# Tests for PS.Cegid.HR.Administration

This directory contains Pester tests for the PS.Cegid.HR.Administration module.

## Test Files

- **PS.Cegid.HR.Administration.Tests.ps1** - Main unit tests for the module
  - Module loading and manifest validation
  - Class definitions and static values
  - Connection functions (Connect-Talentsoft, Test-TSApiConnection)
  - Private helper functions (Build-TSQuery)
  - Public API functions
  - Security validation (no hardcoded credentials)

- **Integration.Tests.ps1** - Integration tests requiring live API credentials
  - Real connection testing
  - Actual API calls
  - Error handling with live API

## Running Tests

### Prerequisites

1. Install Pester 5.x or higher:
   ```powershell
   Install-Module -Name Pester -Force -SkipPublisherCheck
   ```

### Run Unit Tests Only (Recommended)

```powershell
.\Invoke-Tests.ps1 -TestType Unit
```

### Run All Tests with Code Coverage

```powershell
.\Invoke-Tests.ps1 -TestType All -CodeCoverage
```

### Run Integration Tests

Integration tests require real API credentials. Set the following environment variables:

```powershell
$env:TS_BASE_URI = "https://your-tenant.talentsoft.com"
$env:TS_CLIENT_ID = "your-client-id"
$env:TS_CLIENT_SECRET = "your-client-secret"

.\Invoke-Tests.ps1 -TestType Integration
```

### Run Specific Tests

```powershell
# Run tests with specific tags
Invoke-Pester -Path . -Tag Connection

# Run tests excluding specific tags
Invoke-Pester -Path . -ExcludeTag Integration
```

## Test Organization

Tests are organized by tags:

- **Module** - Module loading and manifest tests
- **Connection** - Authentication and connection tests
- **API** - API endpoint tests
- **Individual** - Individual-related API tests
- **Employee** - Employee-related API tests
- **Security** - Security validation tests
- **Private** - Private function tests
- **Helper** - Helper function tests
- **Integration** - Integration tests requiring live credentials

## Test Coverage

The unit tests cover:

✅ Module manifest validation  
✅ Module loading and function export  
✅ Class definitions and instantiation  
✅ Static class values  
✅ Parameter validation for all public functions  
✅ Connection establishment with mocking  
✅ Token creation and session management  
✅ Query string building  
✅ API endpoint paths and HTTP methods  
✅ Security validation (no hardcoded credentials)  

## Continuous Integration

The tests are designed to work in CI/CD pipelines:

```powershell
# Example CI script
.\Invoke-Tests.ps1 -TestType Unit -CodeCoverage -OutputPath .\TestResults
# Exit code 0 = success, 1 = failure
```

## Writing New Tests

When adding new functions to the module, follow this pattern:

```powershell
Describe 'Your-NewFunction' -Tag 'API', 'YourCategory' {
    
    Context 'Parameter Validation' {
        It 'Should require mandatory parameters' {
            { Your-NewFunction } | Should -Throw
        }
    }
    
    Context 'Function Behavior' {
        BeforeAll {
            # Set up mocks
            Mock Invoke-TSApi { return @{} }
        }
        
        It 'Should call the correct API endpoint' {
            Your-NewFunction -Parameter 'value'
            Should -Invoke Invoke-TSApi -ParameterFilter {
                $Path -eq '/expected/path'
            }
        }
    }
}
```

## Test Results

Test results are saved to `TestResults/TestResults.xml` in NUnit format, compatible with most CI/CD systems.

Code coverage reports (when enabled) are saved to `TestResults/Coverage.xml` in JaCoCo format.

## Notes

- Unit tests use mocking and don't require API credentials
- Integration tests are skipped automatically if credentials aren't provided
- All tests are non-destructive and safe to run repeatedly
- Tests follow Pester 5.x syntax and conventions
