---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardTable

## SYNOPSIS
Creates an Adaptive Card Table element.

## SYNTAX

```
New-ACardTable [[-Id] <String>] [-Columns] <Hashtable[]> [-Rows] <Hashtable[]> [-ShowGridLines]
 [[-GridStyle] <ContainerStyle>] [-FirstRowAsHeaders] [[-FirstRowAsHeadersStyle] <ContainerStyle>]
 [[-Spacing] <Spacing>] [-Separator] [[-TargetWidth] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a table with columns and rows for structured data display.

## EXAMPLES

### EXAMPLE 1
```
New-ACardTable -Columns @(
    New-ACardTableColumnDefinition -Width 1
    New-ACardTableColumnDefinition -Width 2
) -Rows @(
    New-ACardTableRow -Cells @(
        New-ACardTableCell -Items @(New-ACardTextBlock -Text "Header 1")
        New-ACardTableCell -Items @(New-ACardTextBlock -Text "Header 2")
    )
) -FirstRowAsHeaders -ShowGridLines
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

### -Columns
Array of column definitions (created with New-ACardTableColumnDefinition).
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

### -Rows
Array of table rows (created with New-ACardTableRow).
Required.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ShowGridLines
When specified, displays grid lines between cells.

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

### -GridStyle
Visual style for the grid lines.

```yaml
Type: ContainerStyle
Parameter Sets: (All)
Aliases:
Accepted values: Default, Emphasis, Good, Attention, Warning, Accent

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstRowAsHeaders
When specified, treats the first row as headers.

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

### -FirstRowAsHeadersStyle
Style to apply when first row is treated as headers.

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

### -Spacing
Controls spacing before the element.

```yaml
Type: Spacing
Parameter Sets: (All)
Aliases:
Accepted values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding

Required: False
Position: 6
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

### -TargetWidth
Specifies the minimum target width (e.g., "AtLeast:Narrow", "AtLeast:Standard").

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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
