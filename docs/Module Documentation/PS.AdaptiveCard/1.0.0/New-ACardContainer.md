---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardContainer

## SYNOPSIS
Creates an Adaptive Card Container element.

## SYNTAX

```
New-ACardContainer [[-Id] <String>] [-Items] <Hashtable[]> [[-Style] <ContainerStyle>]
 [[-VerticalAlign] <VerticalAlignment>] [-Bleed] [[-BackgroundImage] <Hashtable>] [[-MinHeight] <Int32>]
 [[-Spacing] <Spacing>] [-Separator] [[-Height] <Height>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a container that groups elements together with optional styling and background.

## EXAMPLES

### EXAMPLE 1
```
New-ACardContainer -Items @(
    New-ACardTextBlock -Text "Container Title" -Weight Bolder
    New-ACardTextBlock -Text "Container content"
) -Style Emphasis
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

### -Items
Array of elements to include in the container.
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

### -Style
Visual style for the container (emphasis, good, attention, warning, accent).

```yaml
Type: ContainerStyle
Parameter Sets: (All)
Aliases:
Accepted values: Default, Emphasis, Good, Attention, Warning, Accent

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalAlign
Controls vertical alignment of items within the container.

```yaml
Type: VerticalAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Top, Center, Bottom

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Bleed
When specified, allows the container to bleed to the edge of its parent.

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

### -BackgroundImage
Background image for the container (created with New-ACardBackgroundImage).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinHeight
Minimum height in pixels for the container.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
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
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
When specified, draw a separating line at the top of the element.

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
Position: 8
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
