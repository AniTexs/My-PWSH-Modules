---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365UserServiceActivity

## SYNOPSIS
Retrieves Office 365 active user detail report.

## SYNTAX

```
Get-OCM365UserServiceActivity [[-Period] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets detailed active user report showing activity across all Office 365 services.
Returns data about user activity in Exchange, SharePoint, OneDrive, Teams, Yammer, and Skype.

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365UserServiceActivity
Retrieves user service activity for the last 180 days.
```

### EXAMPLE 2
```
Get-OCM365UserServiceActivity -Period D30
Retrieves user service activity for the last 30 days.
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
