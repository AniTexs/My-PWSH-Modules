# Example PowerShell Module Template

This is a template structure for creating new PowerShell modules. Use this as a reference when developing modules in your own repositories.

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

## How to Use This Template

1. **Copy the structure** to create your own module
2. **Replace "ExampleModule"** with your module name throughout all files
3. **Generate a new GUID** for the manifest: `New-Guid`
4. **Update the manifest** with your information (author, description, version)
5. **Implement your functions** in the Public and Private directories
6. **Write tests** for your public functions
7. **Update README.md** with your module documentation

## Quick Start

### 1. Create Module Manifest

```powershell
# Generate a GUID for your module
$guid = New-Guid

# Update the .psd1 file with your information
```

### 2. Implement Functions

Add your functions to the appropriate directory:
- `Public/` - Functions that will be exported and available to users
- `Private/` - Internal helper functions not exposed to users

### 3. Write Tests

Create Pester tests in the `Tests/` directory for your public functions.

### 4. Document Your Module

Update the README.md with:
- What your module does
- How to install it
- Usage examples
- Available functions

## Example Function

Here's an example of a well-structured PowerShell function:

```powershell
function Get-Example {
    <#
    .SYNOPSIS
        Gets an example result.
    
    .DESCRIPTION
        This function demonstrates proper PowerShell function structure
        with parameters, help, and error handling.
    
    .PARAMETER Name
        The name to use in the example.
    
    .PARAMETER Type
        The type of example to return.
    
    .EXAMPLE
        Get-Example -Name "Test"
        Returns an example with the name "Test".
    
    .EXAMPLE
        Get-Example -Name "Test" -Type "Advanced"
        Returns an advanced example with the name "Test".
    
    .NOTES
        Author: Your Name
        Version: 1.0.0
        License: MIT
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter a name for the example"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        [Parameter()]
        [ValidateSet('Basic', 'Advanced', 'Expert')]
        [string]$Type = 'Basic'
    )
    
    begin {
        Write-Verbose "Starting Get-Example function"
    }
    
    process {
        try {
            Write-Verbose "Processing example for: $Name"
            
            # Your function logic here
            $result = [PSCustomObject]@{
                Name = $Name
                Type = $Type
                Timestamp = Get-Date
            }
            
            Write-Output $result
        }
        catch {
            Write-Error "Failed to get example: $_"
        }
    }
    
    end {
        Write-Verbose "Completed Get-Example function"
    }
}
```

## Testing Your Module Locally

```powershell
# Import your module
Import-Module ./ExampleModule/ExampleModule.psd1 -Force

# Test your functions
Get-Example -Name "Test"

# Run Pester tests
Invoke-Pester ./ExampleModule/Tests/

# Run PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path ./ExampleModule/ -Recurse
```

## Remember

- Follow PowerShell best practices
- Use approved verbs (Get-Verb)
- Include comprehensive help
- Write tests for your functions
- Keep functions focused and single-purpose
- Use proper error handling
- Document your code

## Need Help?

Refer to the full [Module Structure Guide](../docs/MODULE_STRUCTURE.md) for detailed information.
