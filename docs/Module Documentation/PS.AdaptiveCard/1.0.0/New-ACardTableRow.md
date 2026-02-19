---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardTableRow

## SYNOPSIS
Creates a table row for Table elements.

## SYNTAX

```
New-ACardTableRow [-Cells] <Hashtable[]> [[-Style] <ContainerStyle>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a row containing table cells.

## EXAMPLES

### EXAMPLE 1
```
New-ACardTableRow -Cells @(
    New-ACardTableCell -Items @(New-ACardTextBlock -Text "Cell 1")
    New-ACardTableCell -Items @(New-ACardTextBlock -Text "Cell 2")
)
```

## PARAMETERS

### -Cells
Array of table cells (created with New-ACardTableCell).
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
Visual style for the row.

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
