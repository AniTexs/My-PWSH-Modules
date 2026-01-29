---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# New-MCPToolDefinition

## SYNOPSIS
Creates a properly formatted MCP tool definition object.

## SYNTAX

```
New-MCPToolDefinition [-Name] <String> [-Description] <String> [-Handler] <Object> [-InputSchema] <Hashtable>
 [[-SubmoduleName] <String>] [[-OutputDescription] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Generates a tool definition that can be returned by a submodule's Get-MCPTools function.
Ensures all required properties are present for proper tool registration and execution.

## EXAMPLES

### EXAMPLE 1
```
$toolDef = New-MCPToolDefinition `
    -Name 'Get-ADUser-Info' `
    -Description 'Retrieves Active Directory user information' `
    -Handler { param($Identity) Get-ADUser -Identity $Identity } `
    -InputSchema @{ Identity = 'User identity (username, email, or SID)' } `
    -OutputDescription 'Returns PSObject with user properties'
```

## PARAMETERS

### -Name
The unique name of the tool.
Used to invoke the tool via Invoke-MCPTool.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A detailed description of what the tool does.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Handler
A scriptblock or function name that executes the tool.
Must accept arguments matching the InputSchema.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputSchema
A hashtable describing the tool's input parameters.
Keys are parameter names, values describe the parameter.
Example: @{ Identity = 'The user identity (username or email)'; Filter = 'LDAP filter string' }

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubmoduleName
Optional.
The name of the submodule that provides this tool.
Auto-populated if not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputDescription
Optional.
Description of the tool's output format.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
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

## NOTES
The Handler scriptblock or function receives arguments as a hashtable that can be splatted.

## RELATED LINKS
