---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# Get-MCPServerStatus

## SYNOPSIS
Returns the current status and statistics of the MCP server.

## SYNTAX

```
Get-MCPServerStatus [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Provides detailed information about the initialized MCP server including:
- Initialization status
- Number of loaded submodules
- Number of registered tools
- Details about each submodule

## EXAMPLES

### EXAMPLE 1
```
Get-MCPServerStatus
```

## PARAMETERS

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
Returns $null if the MCP server has not been initialized.

## RELATED LINKS
