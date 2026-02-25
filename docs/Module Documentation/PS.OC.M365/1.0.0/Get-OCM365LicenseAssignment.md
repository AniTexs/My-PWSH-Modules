---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365LicenseAssignment

## SYNOPSIS
Retrieves all Microsoft 365 licenses and their user assignments.

## SYNTAX

```
Get-OCM365LicenseAssignment [-IncludeFriendlyNames] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets all subscribed SKUs from the tenant and retrieves all users assigned to each license.
Optionally includes friendly names for licenses using the Get-OCM365MicrosoftLicenses function.

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365LicenseAssignment
Retrieves all licenses and their assignments.
```

### EXAMPLE 2
```
Get-OCM365LicenseAssignment -IncludeFriendlyNames
```

## PARAMETERS

### -IncludeFriendlyNames
If specified, includes friendly license names from the Microsoft licensing reference data.
Otherwise, only the SkuPartNumber is used.

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
Requires Microsoft Graph PowerShell module and an active Graph connection.
Required Graph API permissions: Organization.Read.All, User.Read.All

## RELATED LINKS
