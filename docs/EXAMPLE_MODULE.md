# Example PowerShell Module Template

This is an explanation of how the Module structure is.

## Files in this Template

```
ExampleModule/
├── ExampleModule.psd1      # Module manifest
├── ExampleModule.psm1      # Module script file
├── Public/                 # Public functions
│   └── Get-Example.ps1
├── Private/                # Private functions
│   └── Invoke-Helper.ps1
├── Tests/                  # Pester tests
│   └── Get-Example.Tests.ps1
├── README.md              # Module documentation
└── CHANGELOG.md           # Version history
```

## How to make a new Module?

Ehm... Just the script in the root of the repository. [NewModuleCreation.ps1](../NewModuleCreation.ps1)