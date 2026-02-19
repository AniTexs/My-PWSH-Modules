---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardTableCell

## SYNOPSIS
Creates a table cell for TableRow elements.

## SYNTAX

```
New-ACardTableCell [-Items] <Hashtable[]> [[-Style] <ContainerStyle>] [[-VerticalAlign] <VerticalAlignment>]
 [[-RowSpan] <Int32>] [[-ColumnSpan] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a cell containing elements within a table row.

## EXAMPLES

### EXAMPLE 1
```
New-ACardTableCell -Items @(
    New-ACardTextBlock -Text "Cell Content"
)
```

## PARAMETERS

### -Items
Array of elements to display in the cell.
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

### -Style
Visual style for the cell.

```yaml
Type: ContainerStyle
Parameter Sets: (All)
Aliases:
Accepted values: Default, Emphasis, Good, Attention, Warning, Accent

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalAlign
Controls vertical alignment of content within the cell.

```yaml
Type: VerticalAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Top, Center, Bottom

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RowSpan
Number of rows this cell should span.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ColumnSpan
Number of columns this cell should span.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
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
