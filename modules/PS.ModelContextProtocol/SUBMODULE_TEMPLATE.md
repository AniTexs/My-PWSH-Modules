# PS.ModelContextProtocol Submodule Template

This template shows how to create a submodule that wraps existing PowerShell functionality
(like Active Directory) for use as MCP tools available to AI agents.

## Usage

1. Copy this template folder
2. Rename to `PS.ModelContextProtocol.YourModuleName`
3. Implement your tools in the `Public/Get-MCPTools.ps1` file
4. Place the module in the same directory as other PS.ModelContextProtocol.* modules
5. Call `Initialize-MCPServer` in the base module - it will auto-discover your module

## File Structure

```
PS.ModelContextProtocol.YourModuleName/
├── PS.ModelContextProtocol.YourModuleName.psd1    (Module manifest)
├── PS.ModelContextProtocol.YourModuleName.psm1    (Root module file)
├── Public/
│   ├── Get-MCPTools.ps1                          (Required - returns tool definitions)
│   └── [Additional tool files if needed]
├── Private/
│   └── [Helper functions]
└── README.md
```

## Example: Active Directory Submodule

Here's a complete example for `PS.ModelContextProtocol.ActiveDirectory`:

### Step 1: Create Manifest (PS.ModelContextProtocol.ActiveDirectory.psd1)

```powershell
@{
    RootModule          = 'PS.ModelContextProtocol.ActiveDirectory.psm1'
    ModuleVersion       = '1.0.0'
    GUID                = (New-Guid).Guid
    Author              = 'Your Name'
    CompanyName         = 'Your Company'
    Description         = 'Active Directory tools for MCP server'
    PowerShellVersion   = '7.0'
    FunctionsToExport   = @('Get-MCPTools')
}
```

### Step 2: Create Root Module (PS.ModelContextProtocol.ActiveDirectory.psm1)

```powershell
# Get public and private function definition files
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
foreach($import in @($Public + $Private)) {
    Try {
        Write-Verbose "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch {
        Write-Error "Failed to import function $($import.fullname): $_"
    }
}

# Export only the Get-MCPTools function
Export-ModuleMember -Function 'Get-MCPTools'
```

### Step 3: Implement Tools (Public/Get-MCPTools.ps1)

```powershell
function Get-MCPTools {
    <#
        .SYNOPSIS
        Returns all MCP tools provided by the Active Directory integration.

        .DESCRIPTION
        This function is called by the base MCP server to discover and register
        tools from this submodule. It must return an array of tool definitions.
    #>
    [CmdletBinding()]
    param()

    try {
        $tools = @()

        #region Get-ADUser Tool
        $tools += New-MCPToolDefinition `
            -Name 'Get-ADUser-Info' `
            -Description 'Retrieves detailed information about an Active Directory user account' `
            -Handler {
                param($Identity)
                
                if (-not $Identity) {
                    return @{ Error = 'Identity parameter is required' }
                }

                try {
                    $user = Get-ADUser -Identity $Identity -Properties *
                    
                    return @{
                        Success = $true
                        User    = @{
                            Name                = $user.Name
                            SamAccountName      = $user.SamAccountName
                            Email               = $user.Mail
                            DisplayName         = $user.DisplayName
                            Enabled             = $user.Enabled
                            LastLogonDate       = $user.LastLogonDate
                            PasswordLastSet     = $user.PasswordLastSet
                            PasswordNeverExpires = $user.PasswordNeverExpires
                            Department          = $user.Department
                            Title               = $user.Title
                            Manager             = $user.Manager
                        }
                    }
                }
                catch {
                    return @{ Error = "Failed to retrieve user: $($_.Exception.Message)" }
                }
            } `
            -InputSchema @{
                Identity = 'The user identity (username, email, or SID). Required.'
            } `
            -OutputDescription 'Returns @{Success=[bool]; User=[object]} or @{Error=[string]}'
        #endregion

        #region Search-ADUsers Tool
        $tools += New-MCPToolDefinition `
            -Name 'Search-ADUsers' `
            -Description 'Searches for Active Directory users matching specified criteria' `
            -Handler {
                param($Filter, $SearchBase, $MaxResults = 100)
                
                if (-not $Filter) {
                    return @{ Error = 'Filter parameter is required' }
                }

                try {
                    $params = @{
                        Filter          = $Filter
                        ResultSetSize   = $MaxResults
                        Properties      = '*'
                    }
                    
                    if ($SearchBase) {
                        $params['SearchBase'] = $SearchBase
                    }

                    $users = Get-ADUser @params | Select-Object -First $MaxResults | ForEach-Object {
                        @{
                            Name          = $_.Name
                            SamAccountName = $_.SamAccountName
                            Email         = $_.Mail
                            DisplayName   = $_.DisplayName
                            Enabled       = $_.Enabled
                            Department    = $_.Department
                        }
                    }

                    return @{
                        Success = $true
                        Count   = $users.Count
                        Users   = $users
                    }
                }
                catch {
                    return @{ Error = "Search failed: $($_.Exception.Message)" }
                }
            } `
            -InputSchema @{
                Filter = 'LDAP filter string (e.g., "(givenName=John)"). Required.'
                SearchBase = 'The search base DN. Optional.'
                MaxResults = 'Maximum number of results to return. Defaults to 100.'
            } `
            -OutputDescription 'Returns @{Success=[bool]; Count=[int]; Users=[array]} or @{Error=[string]}'
        #endregion

        #region Get-ADGroup Tool
        $tools += New-MCPToolDefinition `
            -Name 'Get-ADGroup-Info' `
            -Description 'Retrieves information about an Active Directory group' `
            -Handler {
                param($Identity)
                
                if (-not $Identity) {
                    return @{ Error = 'Identity parameter is required' }
                }

                try {
                    $group = Get-ADGroup -Identity $Identity -Properties *
                    $members = Get-ADGroupMember -Identity $Identity | Select-Object Name, SamAccountName
                    
                    return @{
                        Success = $true
                        Group   = @{
                            Name        = $group.Name
                            SamAccountName = $group.SamAccountName
                            GroupScope  = $group.GroupScope
                            GroupCategory = $group.GroupCategory
                            Description = $group.Description
                            Mail        = $group.Mail
                            MemberCount = $members.Count
                            Members     = $members
                        }
                    }
                }
                catch {
                    return @{ Error = "Failed to retrieve group: $($_.Exception.Message)" }
                }
            } `
            -InputSchema @{
                Identity = 'The group identity (name or SID). Required.'
            } `
            -OutputDescription 'Returns @{Success=[bool]; Group=[object]} or @{Error=[string]}'
        #endregion

        #region Add-ADGroupMember Tool
        $tools += New-MCPToolDefinition `
            -Name 'Add-ADGroupMember' `
            -Description 'Adds a user to an Active Directory group (requires appropriate permissions)' `
            -Handler {
                param($GroupIdentity, $UserIdentity)
                
                if (-not $GroupIdentity -or -not $UserIdentity) {
                    return @{ Error = 'Both GroupIdentity and UserIdentity parameters are required' }
                }

                try {
                    Add-ADGroupMember -Identity $GroupIdentity -Members $UserIdentity -Confirm:$false
                    
                    return @{
                        Success = $true
                        Message = "User '$UserIdentity' added to group '$GroupIdentity'"
                    }
                }
                catch {
                    return @{ Error = "Failed to add user to group: $($_.Exception.Message)" }
                }
            } `
            -InputSchema @{
                GroupIdentity = 'The group identity (name or SID). Required.'
                UserIdentity = 'The user identity (name or SID). Required.'
            } `
            -OutputDescription 'Returns @{Success=[bool]; Message=[string]} or @{Error=[string]}'
        #endregion

        Write-Verbose "Active Directory MCP tools loaded: $($tools.Count) tools"
        return $tools
    }
    catch {
        Write-Error -ErrorRecord $_
        throw
    }
}
```

## Key Points

1. **Get-MCPTools is Required**: This is the entry point the base MCP server calls
2. **Use New-MCPToolDefinition**: This factory function ensures consistent formatting
3. **Error Handling**: Always return structured error objects, don't throw
4. **Input Validation**: Check required parameters early
5. **Documentation**: Clear descriptions help AI agents understand tools
6. **Output Format**: Return consistent, serializable objects

## Testing Your Submodule

```powershell
# Import the base module
Import-Module PS.ModelContextProtocol

# Initialize (will auto-discover your submodule if placed correctly)
Initialize-MCPServer

# Check if your module loaded
Get-MCPServerStatus

# Get your tools
Get-MCPTools -SubmoduleName 'PS.ModelContextProtocol.ActiveDirectory'

# Test a tool
$result = Invoke-MCPTool -ToolName 'Get-ADUser-Info' -Arguments @{ Identity = 'jdoe' }
$result
```

## Distribution

Once your submodule is ready:
1. Place it in a proper location (e.g., alongside other PS.ModelContextProtocol.* modules)
2. It will be auto-discovered when `Initialize-MCPServer` is called
3. No additional configuration needed!
