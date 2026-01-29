---
external help file: PS.ModelContextProtocol.Generic-help.xml
Module Name: PS.ModelContextProtocol.Generic
online version:
schema: 2.0.0
---

# Get-MCPTools

## SYNOPSIS
Returns MCP tools provided by PS.ModelContextProtocol.Example.

## SYNTAX

```
Get-MCPTools [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This is the required entrypoint for any PS.ModelContextProtocol.* submodule.
The base module calls this function during Initialize-MCPServer to discover tools.

## EXAMPLES

### EXAMPLE 1
```
Get-MCPTools
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

## RELATED LINKS
