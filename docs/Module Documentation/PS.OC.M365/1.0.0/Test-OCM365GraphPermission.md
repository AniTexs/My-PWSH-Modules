---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Test-OCM365GraphPermission

## SYNOPSIS
Tests if the current Microsoft Graph connection has required permissions.

## SYNTAX

```
Test-OCM365GraphPermission [-RequiredPermissions] <String[]> [[-Scopes] <String[]>] [-Details]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Validates that the current Microsoft Graph connection has the required permissions.
Understands permission hierarchies:
- Super-permissions like Directory.ReadWrite.All cover multiple specific permissions
- ReadWrite permissions satisfy Read requirements
- Maintains a permission hierarchy map for accurate validation

## EXAMPLES

### EXAMPLE 1
```
Test-OCM365GraphPermission -RequiredPermissions @('Application.Read.All', 'Directory.Read.All')
Returns $true or $false.
```

### EXAMPLE 2
```
@('User.Read.All', 'Organization.Read.All') | Test-OCM365GraphPermission
Returns $true or $false via pipeline.
```

### EXAMPLE 3
```
Test-OCM365GraphPermission -RequiredPermissions @('User.Read.All') -Scopes $mgContext.Scopes -Details
Returns detailed object with permission analysis.
```

## PARAMETERS

### -RequiredPermissions
Array of required Microsoft Graph permissions to check for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Scopes
Array of current permission scopes from the Graph connection.
If not provided, retrieves from current MgContext.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Details
If specified, returns detailed object with permission analysis instead of boolean.
The returned object includes:
- RequiredPermissions: The permissions that were checked
- GrantedPermissions: The permissions currently available
- MissingPermissions: Any permissions that were not satisfied
- HasAccess: Boolean indicating if all required permissions are available
- Notes: Additional details about the permission check

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean
### Returns $true if all required permissions are satisfied, $false otherwise.
### When -Details is specified:
### PSCustomObject with properties: Item, ItemType, RequiredPermissions, GrantedPermissions, MissingPermissions, HasAccess, Notes
## NOTES
This function understands permission hierarchies:
- Directory.ReadWrite.All covers Application.*, Directory.*, User.*, and Organization.Read.All
- Organization.ReadWrite.All covers Organization.Read.All
- ReadWrite.All covers Read.All of the same resource
- TeamSettings.ReadWrite.All covers Team operations
- Group permissions cover Team operations (Teams are built on Groups)
- TeamMember.ReadWrite.All covers TeamMember.Read.All
- All patterns are case-insensitive

## RELATED LINKS
