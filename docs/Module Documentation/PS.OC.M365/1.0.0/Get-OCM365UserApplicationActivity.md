---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365UserApplicationActivity

## SYNOPSIS
Retrieves Microsoft 365 application activity report for users.

## SYNTAX

```
Get-OCM365UserApplicationActivity [[-Period] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Gets detailed Microsoft 365 application usage report for all users in the tenant.
Returns data about user activity across Microsoft 365 apps like Word, Excel, PowerPoint, etc.

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365UserApplicationActivity
Retrieves application activity for the last 180 days.
```

### EXAMPLE 2
```
Get-OCM365UserApplicationActivity -Period D30
Retrieves application activity for the last 30 days.
```

## PARAMETERS

### -Period
The report period.
Valid values are: D7, D30, D90, D180.
Default is D180 (last 180 days).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: D180
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
Requires Microsoft Graph PowerShell module and an active Graph connection.
Required Graph API permissions: Reports.Read.All

## RELATED LINKS
