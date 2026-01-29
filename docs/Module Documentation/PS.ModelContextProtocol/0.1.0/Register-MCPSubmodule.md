---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# Register-MCPSubmodule

## SYNOPSIS
Manually registers an MCP submodule that may not have been auto-discovered.

## SYNTAX

```
Register-MCPSubmodule [-ModuleName] <String> [[-ModulePath] <String>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Allows explicit registration of a submodule module, even if it's not in the default module path.
Useful for dynamic module loading or modules installed in non-standard locations.

## EXAMPLES

### EXAMPLE 1
```
Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.CustomTools'
```

### EXAMPLE 2
```
Register-MCPSubmodule -ModuleName 'PS.ModelContextProtocol.LegacyAD' -ModulePath 'C:\CustomModules\LegacyAD'
```

## PARAMETERS

### -ModuleName
The name of the module to register.
Should follow PS.ModelContextProtocol.* naming convention.

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

### -ModulePath
Optional.
The full path to the module if not in the standard module search paths.

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
The submodule must export a Get-MCPTools function to be valid.

## RELATED LINKS
