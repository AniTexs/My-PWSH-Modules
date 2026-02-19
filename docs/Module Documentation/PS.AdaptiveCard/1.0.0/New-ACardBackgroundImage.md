---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardBackgroundImage

## SYNOPSIS
Creates a background image for containers or cards.

## SYNTAX

```
New-ACardBackgroundImage [-Url] <String> [[-FillMode] <String>] [[-HorizontalAlign] <String>]
 [[-VerticalAlign] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Defines a background image with positioning and fill options.

## EXAMPLES

### EXAMPLE 1
```
New-ACardBackgroundImage -Url "https://example.com/bg.jpg" -FillMode cover
```

## PARAMETERS

### -Url
URL to the background image.
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

### -FillMode
How the image should fill the space (cover, repeatHorizontally, repeatVertically, repeat).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Cover
Accept pipeline input: False
Accept wildcard characters: False
```

### -HorizontalAlign
Horizontal alignment of the background image.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Center
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalAlign
Vertical alignment of the background image.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Center
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
