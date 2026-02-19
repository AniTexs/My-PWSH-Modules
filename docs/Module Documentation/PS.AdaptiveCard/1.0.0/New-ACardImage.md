---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardImage

## SYNOPSIS
Creates an Adaptive Card Image element.

## SYNTAX

```
New-ACardImage [[-Id] <String>] [-Url] <String> [[-AltText] <String>] [[-Size] <String>]
 [[-HorizontalAlign] <HorizontalAlignment>] [[-BackgroundColor] <String>] [[-Style] <String>]
 [[-Spacing] <Spacing>] [-Separator] [[-Height] <Height>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates an image element for an Adaptive Card with various display options and styling.

## EXAMPLES

### EXAMPLE 1
```
New-ACardImage -Url "https://example.com/image.png" -AltText "Example Image" -Size Medium
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

### -Url
The URL to the image.
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

### -AltText
Alternate text for the image for accessibility.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
Controls the size of the image.
Options: Auto, Stretch, Small, Medium, Large.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Auto
Accept pipeline input: False
Accept wildcard characters: False
```

### -HorizontalAlign
Controls horizontal alignment of the image.

```yaml
Type: HorizontalAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Left, Center, Right

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundColor
Background color for transparent images.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
Display style for the image (Default or Person for circular cropping).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Default
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
Position: 8
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

### -Height
Specifies the height of the element.

```yaml
Type: Height
Parameter Sets: (All)
Aliases:
Accepted values: Auto, Stretch

Required: False
Position: 9
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

## RELATED LINKS
