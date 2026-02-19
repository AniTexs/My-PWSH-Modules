---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardBadge

## SYNOPSIS
Creates an Adaptive Card Badge element.

## SYNTAX

```
New-ACardBadge [[-Id] <String>] [-Text] <String> [[-Size] <String>] [[-Style] <Styles>] [[-Shape] <Shape>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a badge with text, style, and shape options.

## EXAMPLES

### EXAMPLE 1
```
New-ACardBadge -Text "Active" -Style Good -Shape Circular
```

## PARAMETERS

### -Id
A unique identifier for the element.

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

### -Text
The text to display in the badge.
Required.

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

### -Size
The size of the badge (Medium, Large, ExtraLarge).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Large
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
The visual style of the badge.

```yaml
Type: Styles
Parameter Sets: (All)
Aliases:
Accepted values: Default, Subtle, Informative, Accent, Good, Attention, Warning

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Shape
The shape of the badge (Default, Circular, Rounded).

```yaml
Type: Shape
Parameter Sets: (All)
Aliases:
Accepted values: Default, Circular, Rounded

Required: False
Position: 5
Default value: Circular
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
