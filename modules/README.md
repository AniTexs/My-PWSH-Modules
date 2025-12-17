# Modules Directory

This directory contains all PowerShell modules maintained in this repository.

## Current Modules

*No modules have been added yet. Check back later!*

## Module Structure

Each module in this directory follows a standardized structure:

```
ModuleName/
├── ModuleName.psd1      # Module manifest
├── ModuleName.psm1      # Module script file
├── Public/              # Public functions (exported)
├── Private/             # Private functions (internal)
├── Tests/               # Pester tests
├── README.md            # Module documentation
└── CHANGELOG.md         # Version history
```

## Adding a New Module

**Note**: New modules should be created in your own repository. This repository only accepts contributions to existing modules.

For repository maintainers, refer to the [Module Structure Guide](../docs/MODULE_STRUCTURE.md) for detailed information on creating a new module.

## Working with Modules

### Build a Module

```powershell
../build/Build-Module.ps1 -ModuleName YourModule
```

### Test a Module

```powershell
../build/Test-Module.ps1 -ModuleName YourModule
```

### Analyze Module Code

```powershell
../build/Invoke-Analyzer.ps1 -ModuleName YourModule
```

## Documentation

- [Module Structure Guide](../docs/MODULE_STRUCTURE.md)
- [Example Module Template](../docs/EXAMPLE_MODULE.md)
- [Contributing Guidelines](../CONTRIBUTING.md)

## License

All modules in this directory are licensed under the MIT License. See [LICENSE](../LICENSE) for details.
