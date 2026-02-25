---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365MicrosoftLicenses

## SYNOPSIS
Retrieves all Microsoft 365 licenses and their friendly name.

## SYNTAX

```
Get-OCM365MicrosoftLicenses [[-DisplayName] <Object>] [[-SkuPartNumber] <Object>] [[-SkuId] <Object>]
 [[-Type] <String>] [-NoWarningMessage] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets all licenses from Microsoft, All SKU's and service plans included.
Pulls a CSV from Microsoft and imports and groups the licenses by their GUID (SkuId).
Url: https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365MicrosoftLicenses -DisplayName "Microsoft 365 Business Premium"
Retrives all licenses that contain "Microsoft 365 Business Premium" in their display name.
```

### EXAMPLE 2
```
Get-OCM365MicrosoftLicenses -DisplayName "Microsoft 365 Business Premium"
Retrives all licenses that contain "Microsoft 365 Business Premium" in their display name.
```

## PARAMETERS

### -DisplayName
Search for a license by its display name.
It's regex based searching.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkuPartNumber
Get a license only by the SkuPartNumber.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SkuId
Get a license only by the SkuId

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Type
Specifies the type of license to filter by.
Valid values are 'Commerical', 'Goverment', 'Education', and 'Nonprofit'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoWarningMessage
If specified, suppresses warning messages about the reliability of the Type property.

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
