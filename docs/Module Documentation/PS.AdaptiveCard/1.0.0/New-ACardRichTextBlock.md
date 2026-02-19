---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardRichTextBlock

## SYNOPSIS
Creates an Adaptive Card RichTextBlock element.

## SYNTAX

```
New-ACardRichTextBlock [[-Id] <String>] [-Inlines] <Hashtable[]> [[-HorizontalAlign] <HorizontalAlignment>]
 [[-Spacing] <Spacing>] [-Separator] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a rich text block that can contain multiple styled text runs.

## EXAMPLES

### EXAMPLE 1
```
New-ACardRichTextBlock -Inlines @(
    New-ACardTextRun -Text "Bold text" -Weight Bolder
    New-ACardTextRun -Text " normal text"
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

### -Inlines
Array of TextRun elements (created with New-ACardTextRun).
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

### -HorizontalAlign
Controls horizontal alignment of the text.

```yaml
Type: HorizontalAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Left, Center, Right

Required: False
Position: 3
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
Position: 4
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
