# Contributing to My-PWSH-Modules

Thank you for your interest in contributing to this PowerShell module collection! We appreciate your help in making these modules better.

## 🎯 Contribution Guidelines

### What We Accept

**We welcome contributions that:**
- Fix bugs in existing modules
- Improve existing module functionality
- Add features to existing modules
- Improve documentation
- Add or improve tests
- Enhance build and deployment processes

### What We Don't Accept

**Please DO NOT:**
- Submit pull requests with entirely new modules
- Push new modules directly to this repository

### Why This Policy?

This repository is a curated collection of modules maintained by the repository owner. New modules should be:
- Developed in your own repository or fork
- Published to PSGallery independently
- Shared with the community through your own channels

If you have created a new PowerShell module, we encourage you to:
1. Create your own repository for it
2. Publish it to PSGallery
3. Share it with the PowerShell community

## 🚀 How to Contribute

### Prerequisites

- PowerShell 7.0 or higher
- Git
- Pester (for testing)

### Setting Up Your Development Environment

1. **Fork the repository**
   ```powershell
   # Navigate to GitHub and fork the repository
   ```

2. **Clone your fork**
   ```powershell
   git clone https://github.com/YOUR-USERNAME/My-PWSH-Modules.git
   cd My-PWSH-Modules
   ```

3. **Create a feature branch**
   ```powershell
   git checkout -b fix/issue-description
   ```

### Making Changes

1. **Make your changes** to the existing module(s)
2. **Test your changes**
   ```powershell
   # Run tests for the module you modified
   ./build/Test-Module.ps1 -ModuleName YourModuleName
   ```

3. **Ensure code quality**
   ```powershell
   # Run PSScriptAnalyzer
   ./build/Invoke-Analyzer.ps1
   ```

4. **Commit your changes**
   ```powershell
   git add .
   git commit -m "Fix: Description of your fix"
   ```

5. **Push to your fork**
   ```powershell
   git push origin fix/issue-description
   ```

6. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Provide a clear description of your changes

### Commit Message Guidelines

We follow conventional commit format:

- `fix:` for bug fixes
- `feat:` for new features (to existing modules)
- `docs:` for documentation changes
- `test:` for test additions or changes
- `refactor:` for code refactoring
- `chore:` for maintenance tasks

Example:
```
fix: Resolve parameter validation in Get-MyFunction
```

## 📋 Code Standards

- Follow PowerShell best practices and style guidelines
- Use approved PowerShell verbs (Get, Set, New, Remove, etc.)
- Include comment-based help for all functions
- Add Pester tests for new functionality
- Ensure PSScriptAnalyzer passes with no errors

## 🧪 Testing

All changes must include appropriate tests:

```powershell
# Run all tests
./build/Test-All.ps1

# Run tests for a specific module
./build/Test-Module.ps1 -ModuleName YourModule
```

## 📝 Documentation

- Update README.md if you change module functionality
- Update comment-based help in functions
- Add examples where appropriate

## 🔍 Code Review Process

1. All submissions require review
2. Automated checks must pass (CI/CD)
3. At least one maintainer approval is required
4. Changes should be minimal and focused

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License. All modules in this repository are under the MIT License.

## ❓ Questions?

If you have questions about contributing, please:
- Open an issue for discussion
- Check existing issues and pull requests
- Review the repository documentation

## 🙏 Thank You!

Your contributions help make these PowerShell modules better for everyone. We appreciate your time and effort!
