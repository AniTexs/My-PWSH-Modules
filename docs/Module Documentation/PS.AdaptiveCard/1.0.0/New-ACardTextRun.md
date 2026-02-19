---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardTextRun

## SYNOPSIS
Creates a TextRun for use in RichTextBlock elements.

## SYNTAX

```
New-ACardTextRun [-Text] <String> [[-Size] <FontSize>] [[-Weight] <FontWeight>] [[-Color] <FontColor>]
 [-Subtle] [-Italic] [-Strikethrough] [-Underline] [-Highlight] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a styled text run that can be used within a RichTextBlock.

## EXAMPLES

### EXAMPLE 1
```
New-ACardTextRun -Text "Important" -Weight Bolder -Color Attention
```

## PARAMETERS

### -Text
The text content.
Required.

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

### -Size
Font size for the text.

```yaml
Type: FontSize
Parameter Sets: (All)
Aliases:
Accepted values: Small, Default, Medium, Large, ExtraLarge

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Weight
Font weight (thickness) for the text.

```yaml
Type: FontWeight
Parameter Sets: (All)
Aliases:
Accepted values: Lighter, Default, Bolder

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color
Color of the text.

```yaml
Type: FontColor
Parameter Sets: (All)
Aliases:
Accepted values: Default, Dark, Light, Accent, Good, Warning, Attention

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subtle
When specified, displays the text in a subtle/muted style.

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

### -Italic
When specified, displays the text in italic style.

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

### -Strikethrough
When specified, displays the text with strikethrough.

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

### -Underline
When specified, displays the text underlined.

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

### -Highlight
When specified, highlights the text.

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
