---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# Invoke-MCPTool

## SYNOPSIS
Executes an MCP tool by name with provided arguments.

## SYNTAX

```
Invoke-MCPTool [-ToolName] <String> [[-Arguments] <Hashtable>] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Invokes a registered MCP tool with the specified input parameters.
The tool must have been registered via Initialize-MCPServer.

## EXAMPLES

### EXAMPLE 1
```
$result = Invoke-MCPTool -ToolName 'Get-ADUser' -Arguments @{ Identity = 'jdoe' }
```

### EXAMPLE 2
```
Invoke-MCPTool -ToolName 'Search-ADObject' -Arguments @{
    Filter = '(objectClass=user)'
    SearchBase = 'OU=Users,DC=example,DC=com'
}
```

## PARAMETERS

### -ToolName
The name of the tool to execute.
Must be an exact match.

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

### -Arguments
A hashtable of arguments to pass to the tool.
The keys must match the tool's input schema.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
This function will throw an error if the tool is not found or if execution fails.
The tool handler is responsible for validating input against the schema.

## RELATED LINKS
