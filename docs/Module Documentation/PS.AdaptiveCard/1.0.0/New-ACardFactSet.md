---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardFactSet

## SYNOPSIS
Creates an Adaptive Card FactSet element.

## SYNTAX

```
New-ACardFactSet [[-Id] <String>] [-Facts] <Hashtable[]> [[-Spacing] <Spacing>] [-Separator]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a set of facts displayed in a two-column layout (title and value).

## EXAMPLES

### EXAMPLE 1
```
New-ACardFactSet -Facts @(
    New-ACardFact -Title "Name" -Value "John Doe"
    New-ACardFact -Title "Email" -Value "john@example.com"
)
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

### -Facts
Array of Fact objects (created with New-ACardFact).
Required.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Spacing
Controls spacing before the element.

```yaml
Type: Spacing
Parameter Sets: (All)
Aliases:
Accepted values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
When true, draw a separating line at the top of the element.

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

## RELATED LINKS
