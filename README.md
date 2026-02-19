# My-PWSH-Modules

I humbly welcome you to my little repo here :p

Collection of PowerShell modules maintained in a single repository with automated build, test, and publish workflows.

> And yes, the markdown files are mostly AI Written, mainly because I suck at explaining stuff.
> I do use Copilot but for line completion and complex logic help :) nothing in this repository is built only by AI.

## 📋 Overview

This repository serves as a centralized collection of PowerShell modules. Each module is independently versioned and can be published to the PowerShell Gallery (PSGallery). The repository includes a comprehensive build system with automated testing, code analysis, and publishing capabilities.

## 📦 Available Modules

Here you can view the Modules which currently exist in this Repository.

|Module Name|Description|Link|
|-|-|-|
|PS.Capa.CapaOne|Unofficial API Wrapper for CapaSystems CapaOne|[PS.Capa.CapaOne](./modules/PS.Capa.CapaOne/)|
|PS.ElasticShell|API Wrapper for interacting with ElasticSearch|[PS.ElasticShell](./modules/PS.ElasticShell/)|
|PS.OC.Utilities|A module containing generic simple helper functions.|[PS.OC.Utilities](./modules/PS.OC.Utilities/)|
|PS.PasswordState|Module to interact with PasswordState and works with SecretManagement to create vaults.|[PS.PasswordState](./modules/PS.PasswordState/)|
|PS.ModelContextProtocol||[PS.ModelContextProtocol](./modules/PS.ModelContextProtocol/)|
|PS.ModelContextProtocol.Example|A refernece module on how to create additional MCP Tools.|[PS.ModelContextProtocol.Example](./modules/PS.ModelContextProtocol/)|
|PS.ModelContextProtocol.Generic|Generic MCP Tools.|[PS.ModelContextProtocol.Generic](./modules/PS.ModelContextProtocol/)|
|PS.AdaptiveCard|Adaptive Card creation from Powershell|[PS.AdaptiveCard](./modules/PS.AdaptiveCard/)|

To see all modules, check the [modules](./modules) directory.

## 🚀 Getting Started

### Prerequisites

- PowerShell 7.0 or higher
- Git
- (Optional) Pester for testing
- (Optional) PSScriptAnalyzer for code quality checks

### Installation

Each module can be installed from PSGallery once published:

```powershell
Install-Module -Name ModuleName -Repository PSGallery
```

### Development Setup

1. Clone this repository:
   ```powershell
   git clone https://github.com/AniTexs/My-PWSH-Modules.git
   cd My-PWSH-Modules
   ```

2. Explore the modules:
   ```powershell
   Get-ChildItem ./modules
   ```

3. Import a module locally:
   ```powershell
   Import-Module ./modules/ModuleName/ModuleName.psd1
   ```

## 🏗️ Repository Structure

```
My-PWSH-Modules/
├── modules/              # All PowerShell modules
│   └── ModuleName/      # Individual module directory
├── build/               # Build and automation scripts
├── .github/workflows/   # GitHub Actions CI/CD
├── docs/                # Documentation
├── CONTRIBUTING.md      # Contribution guidelines
├── LICENSE              # MIT License
└── README.md           # This file
```

For detailed information about module structure, see [Module Structure Guide](./docs/MODULE_STRUCTURE.md).

## 🛠️ Build and Test

This repository includes PowerShell scripts for building, testing, and publishing modules.

### Build a Module

```powershell
./build/Build-Module.ps1 -ModuleName YourModule
```

### Run Tests

```powershell
# Test a specific module
./build/Test-Module.ps1 -ModuleName YourModule

# Test all modules
./build/Test-All.ps1
```

### Code Analysis

```powershell
# Analyze a specific module
./build/Invoke-Analyzer.ps1 -ModuleName YourModule

# Analyze all modules
./build/Invoke-Analyzer.ps1
```

### Publish to PSGallery

```powershell
# First, build the module
./build/Build-Module.ps1 -ModuleName YourModule

# Then publish (requires PSGallery API key)
./build/Publish-Module.ps1 -ModuleName YourModule -ApiKey $env:PSGALLERY_API_KEY
```

## 🔄 CI/CD Pipeline

This repository uses GitHub Actions for continuous integration and deployment:

- **CI Pipeline** (`ci.yml`): Runs on every push and pull request
  - Builds all modules
  - Runs PSScriptAnalyzer
  - Executes all tests
  - Runs on Ubuntu, Windows, and macOS

- **Publish Pipeline** (`publish.yml`): Publishes modules to PSGallery
  - Triggered by releases or manual workflow dispatch
  - Validates and builds the module
  - Publishes to PowerShell Gallery

### Publishing a Module

To publish a module to PSGallery:

1. Ensure your module version is updated in the manifest
2. Create a release tag: `ModuleName-v1.0.0`
3. The GitHub Action will automatically publish to PSGallery

Or use manual workflow dispatch with the module name.

## 🤝 Contributing

**Important**: This repository accepts contributions to existing modules only. New modules should be created in your own repository.

We welcome contributions that:
- Fix bugs in existing modules
- Improve existing module functionality
- Enhance documentation
- Add tests

**We do not accept:**
- New modules (create your own repository instead)
- Direct pushes of new modules

Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Guide

1. Fork the repository
2. Create a feature branch (`git checkout -b fix/your-fix`)
3. Make your changes to existing modules
4. Run tests and ensure they pass
5. Commit your changes (`git commit -m 'Fix: description'`)
6. Push to your fork (`git push origin fix/your-fix`)
7. Open a Pull Request

## 📄 License

This repository and all modules within it are licensed under the **MIT License**. See [LICENSE](./LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Nicolai Jacobsen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

## 📚 Documentation

- [Module Structure Guide](./docs/MODULE_STRUCTURE.md) - Detailed guide on module structure and best practices
- [Example Module Template](./docs/EXAMPLE_MODULE.md) - Template for creating new modules in your own repository
- [Contributing Guidelines](./CONTRIBUTING.md) - How to contribute to existing modules

## 🔧 Maintenance

### Adding a New Module (Repository Owner)

When adding a new module to this repository:

1. Create the module directory: `modules/ModuleName/`
2. Follow the [Module Structure Guide](./docs/MODULE_STRUCTURE.md)
3. Ensure the module has:
   - Module manifest (`.psd1`)
   - Module script file (`.psm1`)
   - README.md
   - Tests
4. Test locally before committing
5. Update this README to list the new module

## 🐛 Issues and Support

If you encounter issues with any module:

1. Check the module's README for documentation
2. Search existing issues in this repository
3. Open a new issue with:
   - Module name and version
   - Description of the issue
   - Steps to reproduce
   - Expected vs actual behavior

## 🌟 Acknowledgments

Thank you to all contributors who help improve these modules!

## 📞 Contact

For questions or discussions, please open an issue in this repository.

---

**Note**: If you've created your own PowerShell module, we encourage you to publish it in your own repository and share it with the PowerShell community independently!
