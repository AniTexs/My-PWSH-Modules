---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# Start-MCPStdioServer

## SYNOPSIS
Starts a minimal MCP-compatible JSON-RPC server over STDIO.

## SYNTAX

```
Start-MCPStdioServer [[-ModulePath] <String>] [-ForceInitialize] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Runs an event loop that reads JSON-RPC messages from stdin and writes responses to stdout.
Designed to be used with VS Code / Copilot MCP "type": "stdio".

Supported methods:
- initialize
- tools/list
- tools/call
- notifications/initialized (no-op)

## EXAMPLES

### EXAMPLE 1
```
Start-MCPStdioServer
```

## PARAMETERS

### -ModulePath
The directory that contains PS.ModelContextProtocol.* submodules.
Defaults to the parent folder of this module.

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

### -ForceInitialize
Forces reinitialization of the tool registry on server start.

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

## NOTES
Do not write non-protocol output to stdout.
Logging is written to stderr.

## RELATED LINKS
