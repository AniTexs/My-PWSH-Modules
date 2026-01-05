# Quick Test Reference - PS.Cegid.HR.Administration

## Running Tests

### Quick Start
```powershell
cd .\modules\PS.Cegid.HR.Administration\Tests
.\Invoke-Tests.ps1
```

### Test Options
```powershell
# Unit tests only (default, no credentials needed)
.\Invoke-Tests.ps1 -TestType Unit

# With code coverage
.\Invoke-Tests.ps1 -TestType Unit -CodeCoverage

# Integration tests (requires credentials)
$env:TS_BASE_URI = "https://your-tenant.talentsoft.com"
$env:TS_CLIENT_ID = "your-client-id"
$env:TS_CLIENT_SECRET = "your-client-secret"
.\Invoke-Tests.ps1 -TestType Integration

# All tests
.\Invoke-Tests.ps1 -TestType All
```

### Direct Pester Commands
```powershell
# Run specific test file
Invoke-Pester -Path .\PS.Cegid.HR.Administration.Tests.ps1

# Run tests with specific tag
Invoke-Pester -Path . -Tag Connection

# Exclude integration tests
Invoke-Pester -Path . -ExcludeTag Integration
```

## Test Coverage Summary

✅ **34 Unit Tests** - All Passing
- 9 Module & Class tests
- 5 Connect-Talentsoft tests
- 3 Test-TSApiConnection tests
- 4 Build-TSQuery tests
- 4 Get-TSIndividual tests
- 2 Get-TSIndividuals tests
- 3 Get-TSEmployee tests
- 4 Security validation tests

🔒 **Security Tests**
- No hardcoded passwords
- No hardcoded API keys
- No hardcoded tokens
- Credentials required as parameters

## Test Structure

```
Tests/
├── PS.Cegid.HR.Administration.Tests.ps1  (Unit tests)
├── Integration.Tests.ps1                  (Integration tests)
├── Invoke-Tests.ps1                       (Test runner)
└── README.md                              (Documentation)
```

## CI/CD Integration

```yaml
# Example GitHub Actions/Azure DevOps
- name: Run Tests
  shell: pwsh
  run: |
    cd modules/PS.Cegid.HR.Administration/Tests
    .\Invoke-Tests.ps1 -TestType Unit -CodeCoverage
```

## Adding New Tests

1. Open `PS.Cegid.HR.Administration.Tests.ps1`
2. Add new Describe block for your function
3. Include parameter validation and behavior tests
4. Run tests to verify

Example:
```powershell
Describe 'Your-NewFunction' -Tag 'API' {
    Context 'Parameter Validation' {
        It 'Should require mandatory parameters' {
            $command = Get-Command -Name Your-NewFunction
            $command.Parameters['YourParam'].Attributes.Mandatory | Should -Contain $true
        }
    }
}
```
