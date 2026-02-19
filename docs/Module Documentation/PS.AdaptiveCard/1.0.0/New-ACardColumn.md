---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardColumn

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Stretch (Default)
```
New-ACardColumn [-Id <String>] -Items <Hashtable[]> [-Height <Height>] [-MinimumPixelHeight <Int32>]
 [-VerticalAlign <VerticalAlignment>] [-RightToLeft] [-Seperator] [-Spacing <Spacing>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AutoWidth
```
New-ACardColumn [-Id <String>] -Items <Hashtable[]> [-AutomaticWidth] [-Height <Height>]
 [-MinimumPixelHeight <Int32>] [-VerticalAlign <VerticalAlignment>] [-RightToLeft] [-Seperator]
 [-Spacing <Spacing>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### StretchWidth
```
New-ACardColumn [-Id <String>] -Items <Hashtable[]> [-StretchWidth] [-Height <Height>]
 [-MinimumPixelHeight <Int32>] [-VerticalAlign <VerticalAlignment>] [-RightToLeft] [-Seperator]
 [-Spacing <Spacing>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### WeightedWidth
```
New-ACardColumn [-Id <String>] -Items <Hashtable[]> [-WeightedWidth] [-WidthValue <Int32>] [-Height <Height>]
 [-MinimumPixelHeight <Int32>] [-VerticalAlign <VerticalAlignment>] [-RightToLeft] [-Seperator]
 [-Spacing <Spacing>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### PixelsWidth
```
New-ACardColumn [-Id <String>] -Items <Hashtable[]> [-PixelsWidth] [-WidthValue <Int32>] [-Height <Height>]
 [-MinimumPixelHeight <Int32>] [-VerticalAlign <VerticalAlignment>] [-RightToLeft] [-Seperator]
 [-Spacing <Spacing>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AutomaticWidth
{{ Fill AutomaticWidth Description }}

```yaml
Type: SwitchParameter
Parameter Sets: AutoWidth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Height
{{ Fill Height Description }}

```yaml
Type: Height
Parameter Sets: (All)
Aliases:
Accepted values: Auto, Stretch

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Items
{{ Fill Items Description }}

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinimumPixelHeight
{{ Fill MinimumPixelHeight Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PixelsWidth
{{ Fill PixelsWidth Description }}

```yaml
Type: SwitchParameter
Parameter Sets: PixelsWidth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RightToLeft
{{ Fill RightToLeft Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Seperator
{{ Fill Seperator Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Spacing
{{ Fill Spacing Description }}

```yaml
Type: Spacing
Parameter Sets: (All)
Aliases:
Accepted values: None, ExtraSmall, Small, Default, Medium, Large, ExtraLarge, Padding

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StretchWidth
{{ Fill StretchWidth Description }}

```yaml
Type: SwitchParameter
Parameter Sets: StretchWidth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VerticalAlign
{{ Fill VerticalAlign Description }}

```yaml
Type: VerticalAlignment
Parameter Sets: (All)
Aliases:
Accepted values: Top, Center, Bottom

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeightedWidth
{{ Fill WeightedWidth Description }}

```yaml
Type: SwitchParameter
Parameter Sets: WeightedWidth
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WidthValue
{{ Fill WidthValue Description }}

```yaml
Type: Int32
Parameter Sets: WeightedWidth, PixelsWidth
Aliases:

Required: False
Position: Named
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
