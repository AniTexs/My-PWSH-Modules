---
external help file: PS.AdaptiveCard-help.xml
Module Name: PS.AdaptiveCard
online version:
schema: 2.0.0
---

# New-ACardActionOpenUrl

## SYNOPSIS
Creates an Action.OpenUrl action.

## SYNTAX

```
New-ACardActionOpenUrl [-Title] <String> [-Url] <String> [[-Style] <Styles>] [[-Mode] <Mode>]
 [[-IconUrl] <String>] [[-Tooltip] <String>] [-Disabled] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Creates an action that opens a URL when invoked.

## EXAMPLES

### EXAMPLE 1
```
New-ACardActionOpenUrl -Title "Visit Website" -Url "https://example.com"
```

## PARAMETERS

### -Title
Label for the action button.
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

### -Url
The URL to open.
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

### -Style
Visual style for the action button.

```yaml
Type: Styles
Parameter Sets: (All)
Aliases:
Accepted values: Default, Positive, Destructive

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mode
Display mode for the action (Primary or Secondary).

```yaml
Type: Mode
Parameter Sets: (All)
Aliases:
Accepted values: Primary, Secondary

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconUrl
Optional icon to display on the button.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tooltip
Tooltip text to display on hover.

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

### -Disabled
When specified, the action is disabled.

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
