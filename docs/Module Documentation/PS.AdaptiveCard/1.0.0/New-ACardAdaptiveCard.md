---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardAdaptiveCard

## SYNOPSIS
Creates an Adaptive Card.

## SYNTAX

```
New-ACardAdaptiveCard [-Body] <Hashtable[]> [[-Actions] <Hashtable[]>] [[-ProviderId] <Guid>]
 [[-Version] <String>] [[-Style] <ContainerStyle>] [[-BackgroundImage] <Hashtable>] [[-MinHeight] <Int32>]
 [[-VerticalAlign] <VerticalAlignment>] [[-Speak] <String>] [[-Lang] <String>] [-HideOriginalBody]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates the root Adaptive Card object and converts it to JSON.

## EXAMPLES

### EXAMPLE 1
```
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "Hello World" -Size Large
)
```

### EXAMPLE 2
```
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "Survey" -Style Heading
    New-ACardInputText -Id "feedback" -Label "Your Feedback" -IsMultiline
) -Actions @(
    New-ACardActionSubmit -Title "Submit"
)
```

## PARAMETERS

### -Body
Array of card elements to include in the card body.
Required.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Actions
Array of actions to display at the bottom of the card.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProviderId
{{ Fill ProviderId Description }}

```yaml
Type: Guid
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Adaptive Card schema version.
Default is "1.6".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1.6
Accept pipeline input: False
Accept wildcard characters: False
```

### -Style
Visual style for the card container.

```yaml
Type: ContainerStyle
Parameter Sets: (All)
Aliases:
Accepted values: Default, Emphasis, Good, Attention, Warning, Accent

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackgroundImage
Background image for the card (created with New-ACardBackgroundImage).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinHeight
Minimum height in pixels for the card.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalAlign
Controls vertical alignment of content within the card.

```yaml
Type: VerticalAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Top, Center, Bottom

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Speak
Text to be spoken for accessibility.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Lang
Language of the card content (e.g., "en-US").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideOriginalBody
{{ Fill HideOriginalBody Description }}

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
