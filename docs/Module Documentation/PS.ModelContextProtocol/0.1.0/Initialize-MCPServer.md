---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# Initialize-MCPServer

## SYNOPSIS
Initializes the MCP (Model Context Protocol) server and discovers available submodules.

## SYNTAX

```
Initialize-MCPServer [[-Path] <String>] [-Force] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Sets up the MCP server infrastructure and automatically discovers and registers all PS.ModelContextProtocol.* submodules.
Each submodule should export a Get-MCPTools function that returns available tools for AI agents.

## EXAMPLES

### EXAMPLE 1
```
Initialize-MCPServer
```

Initialize-MCPServer -Path 'C:\MyModules'

### EXAMPLE 2
```
Initialize-MCPServer -Force
```

## PARAMETERS

### -Path
The path where PS.ModelContextProtocol submodules are installed.
Defaults to the Modules directory containing this module.

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

### -Force
If specified, reinitializes the MCP server and reloads all submodules.

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
Submodules should follow this naming convention: PS.ModelContextProtocol.{SubModuleName}
Each submodule must export a Get-MCPTools function that returns tool definitions.

## RELATED LINKS
