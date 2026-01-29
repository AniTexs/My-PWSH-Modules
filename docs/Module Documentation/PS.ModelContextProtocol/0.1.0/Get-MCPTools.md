---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# Get-MCPTools

## SYNOPSIS
Retrieves all available MCP tools from loaded submodules.

## SYNTAX

```
Get-MCPTools [[-Name] <String>] [[-SubmoduleName] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns a list of all tools that have been registered by submodules.
Each tool includes its name, description, input schema, and handler function.

## EXAMPLES

### EXAMPLE 1
```
Get-MCPTools
```

### EXAMPLE 2
```
Get-MCPTools -Name '*ActiveDirectory*'
```

### EXAMPLE 3
```
Get-MCPTools -SubmoduleName 'PS.ModelContextProtocol.ActiveDirectory'
```

## PARAMETERS

### -Name
Optional.
Filter tools by name pattern.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubmoduleName
Optional.
Filter tools by the submodule that provides them.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
This function returns tools from the global MCP context that was initialized by Initialize-MCPServer.

## RELATED LINKS
