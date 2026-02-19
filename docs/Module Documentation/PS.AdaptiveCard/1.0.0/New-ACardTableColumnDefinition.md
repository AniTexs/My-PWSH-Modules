---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardTableColumnDefinition

## SYNOPSIS
Creates a column definition for Table elements.

## SYNTAX

```
New-ACardTableColumnDefinition [[-Width] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Defines the width for a table column.

## EXAMPLES

### EXAMPLE 1
```
New-ACardTableColumnDefinition -Width 2
```

### EXAMPLE 2
```
New-ACardTableColumnDefinition -Width "auto"
```

## PARAMETERS

### -Width
Width of the column.
Can be a number (relative weight) or "auto"/"stretch".

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1
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

## RELATED LINKS
