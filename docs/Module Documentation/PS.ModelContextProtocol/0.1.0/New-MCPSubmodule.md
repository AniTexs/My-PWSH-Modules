---
external help file: PS.ModelContextProtocol-help.xml
Module Name: PS.ModelContextProtocol
online version:
schema: 2.0.0
---

# New-MCPSubmodule

## SYNOPSIS
Creates a new Model Context Protocol (MCP) submodule object.

## SYNTAX

```
New-MCPSubmodule [-Name] <String> [-Version] <String> [-Description] <String> [-Path] <String>
 [[-Author] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-MCPSubmodule function creates a new MCP submodule object with the specified properties.
This object can be used to define submodules within a larger MCP model context.

## EXAMPLES

### EXAMPLE 1
```
$submodule = New-MCPSubmodule -Name "UserManagement" -Version "1.0.0" -Description "Handles user authentication and authorization."
```

This example creates a new MCP submodule named "UserManagement" with version "1.0.0" and a description.

## PARAMETERS

### -Name
The name of the submodule.

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

### -Version
The version of the submodule.

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

### -Description
A brief description of the submodule.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Author
{{ Fill Author Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

### PSCustomObject representing the MCP submodule.
## NOTES
This function is part of the PS.ModelContextProtocol module.

## RELATED LINKS
