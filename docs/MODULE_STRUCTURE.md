# Module Structure Guide

This document describes the structure and organization of PowerShell modules in this repository.

## Directory Structure

```
My-PWSH-Modules/
├── modules/                    # All PowerShell modules
│   ├── ModuleName1/
│   │   ├── ModuleName1.psd1   # Module manifest
│   │   ├── ModuleName1.psm1   # Module script file
│   │   ├── Public/            # Public functions (exported)
│   │   │   └── *.ps1
│   │   ├── Private/           # Private functions (internal)
│   │   │   └── *.ps1
│   │   ├── Tests/             # Pester tests
│   │   │   └── *.Tests.ps1
│   │   ├── README.md          # Module documentation
│   │   └── CHANGELOG.md       # Version history
│   └── ModuleName2/
│       └── ...
├── build/                      # Build and automation scripts
│   ├── Build-Module.ps1       # Build a module
│   ├── Test-Module.ps1        # Test a module
│   ├── Test-All.ps1           # Test all modules
│   ├── Invoke-Analyzer.ps1    # Run PSScriptAnalyzer
│   └── Publish-Module.ps1     # Publish to PSGallery
├── .github/
│   └── workflows/             # GitHub Actions workflows
│       ├── ci.yml             # CI pipeline
│       └── publish.yml        # Publish to PSGallery
├── docs/                       # Documentation
│   └── MODULE_STRUCTURE.md    # This file
├── output/                     # Build output (gitignored)
├── TestResults/               # Test results (gitignored)
├── CONTRIBUTING.md            # Contribution guidelines
├── LICENSE                    # MIT License
└── README.md                  # Repository readme
```

## Individual Module Structure

Each module should follow this structure:

### Required Files

#### 1. Module Manifest (`.psd1`)

The module manifest file contains metadata about your module.

```powershell
@{
    # Module information
    ModuleVersion = '1.0.0'
    GUID = 'unique-guid-here'
    Author = 'Your Name'
    CompanyName = 'Your Company'
    Copyright = '(c) Year Your Name. All rights reserved.'
    Description = 'Description of what your module does'
    
    # PowerShell version
    PowerShellVersion = '7.0'
    
    # Root module
    RootModule = 'ModuleName.psm1'
    
    # Functions to export
    FunctionsToExport = @('Get-Something', 'Set-Something')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    
    # Private data
    PrivateData = @{
        PSData = @{
            Tags = @('Tag1', 'Tag2')
            LicenseUri = 'https://github.com/YourUser/My-PWSH-Modules/blob/main/LICENSE'
            ProjectUri = 'https://github.com/YourUser/My-PWSH-Modules'
            ReleaseNotes = 'Initial release'
        }
    }
}
```

**Generate a new GUID with:**
```powershell
New-Guid
```

#### 2. Module Script File (`.psm1`)

The main module file that loads public and private functions.

```powershell
# Get public and private function definition files
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

# Export public functions
Export-ModuleMember -Function $Public.BaseName
```

#### 3. README.md

Module documentation with:
- Description
- Installation instructions
- Usage examples
- Function documentation
- Requirements
- License information

### Recommended Structure

#### Public Functions Directory

Place all exported (public) functions in `Public/*.ps1`:

```powershell
# Public/Get-Something.ps1

function Get-Something {
    <#
    .SYNOPSIS
        Brief description of the function.
    
    .DESCRIPTION
        Detailed description of what the function does.
    
    .PARAMETER Name
        Description of the parameter.
    
    .EXAMPLE
        Get-Something -Name "Example"
        
        Description of what this example does.
    
    .NOTES
        Author: Your Name
        License: MIT
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    
    # Function implementation
}
```

#### Private Functions Directory

Place internal helper functions in `Private/*.ps1`:

```powershell
# Private/Invoke-HelperFunction.ps1

function Invoke-HelperFunction {
    [CmdletBinding()]
    param(
        [string]$InputData
    )
    
    # Helper function implementation
}
```

#### Tests Directory

Create Pester tests in `Tests/*.Tests.ps1`:

```powershell
# Tests/Get-Something.Tests.ps1

BeforeAll {
    $ModuleName = 'ModuleName'
    $ModulePath = Split-Path -Parent $PSScriptRoot
    $ManifestPath = Join-Path $ModulePath "$ModuleName.psd1"
    
    if (Get-Module $ModuleName) {
        Remove-Module $ModuleName -Force
    }
    
    Import-Module $ManifestPath -Force
}

Describe 'Get-Something' {
    Context 'Parameter validation' {
        It 'Should have Name as mandatory parameter' {
            (Get-Command Get-Something).Parameters['Name'].Attributes.Mandatory | Should -Be $true
        }
    }
    
    Context 'Functionality' {
        It 'Should return expected result' {
            $result = Get-Something -Name "Test"
            $result | Should -Not -BeNullOrEmpty
        }
    }
}

AfterAll {
    if (Get-Module $ModuleName) {
        Remove-Module $ModuleName -Force
    }
}
```

## Best Practices

### Naming Conventions

1. **Module Names**: Use PascalCase (e.g., `MyAwesomeModule`)
2. **Functions**: Use approved PowerShell verbs (Get, Set, New, Remove, etc.)
   - Check approved verbs: `Get-Verb`
3. **Parameters**: Use PascalCase (e.g., `$InputPath`)
4. **Variables**: Use camelCase for local variables (e.g., `$myVariable`)

### Function Guidelines

1. Always include comment-based help
2. Use `[CmdletBinding()]` for advanced functions
3. Define parameter types explicitly
4. Use parameter validation attributes
5. Follow the Verb-Noun naming pattern
6. Return objects, not formatted text

### Testing Guidelines

1. Test all public functions
2. Test error conditions
3. Test parameter validation
4. Use meaningful test descriptions
5. Organize tests with `Describe` and `Context`

### Documentation

1. Keep README.md up to date
2. Document breaking changes in CHANGELOG.md
3. Include usage examples
4. Document prerequisites and dependencies

## Building and Testing

### Build a Module

```powershell
./build/Build-Module.ps1 -ModuleName YourModule
```

### Run Tests

```powershell
# Test specific module
./build/Test-Module.ps1 -ModuleName YourModule

# Test all modules
./build/Test-All.ps1
```

### Run Code Analysis

```powershell
# Analyze specific module
./build/Invoke-Analyzer.ps1 -ModuleName YourModule

# Analyze all modules
./build/Invoke-Analyzer.ps1
```

### Publish to PSGallery

```powershell
# Build first
./build/Build-Module.ps1 -ModuleName YourModule

# Then publish
./build/Publish-Module.ps1 -ModuleName YourModule -ApiKey $env:PSGALLERY_API_KEY
```

## Versioning

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** version: Incompatible API changes
- **MINOR** version: Add functionality (backwards compatible)
- **PATCH** version: Bug fixes (backwards compatible)

Example: `1.2.3`

## License

All modules in this repository are licensed under the MIT License.

## Support

For questions or issues:
1. Check existing documentation
2. Search existing issues
3. Open a new issue with detailed information
