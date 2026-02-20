---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365AppRegistrationsExpiring

## SYNOPSIS
Retrieves Azure AD application registrations with expiring or expired credentials.

## SYNTAX

```
Get-OCM365AppRegistrationsExpiring [-ClientSecretsOnly] [-CertificatesOnly] [[-SoonToExpireInDays] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets all application registrations and identifies client secrets and certificates that are expired or expiring soon.
Includes application owner information and credential expiry details.

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365AppRegistrationsExpiring
Retrieves all credentials (secrets and certificates) expiring within 60 days.
```

### EXAMPLE 2
```
Get-OCM365AppRegistrationsExpiring -ClientSecretsOnly -SoonToExpireInDays 30
Retrieves only client secrets expiring within 30 days.
```

### EXAMPLE 3
```
Get-OCM365AppRegistrationsExpiring -CertificatesOnly -SoonToExpireInDays 90
Retrieves only certificates expiring within 90 days.
```

## PARAMETERS

### -ClientSecretsOnly
If specified, only displays expiring/expired client secrets (excludes certificates).

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

### -CertificatesOnly
If specified, only displays expiring/expired certificates (excludes client secrets).

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

### -SoonToExpireInDays
Number of days to consider credentials as "soon to expire".
Default is 60 days.
Only credentials expiring within this threshold will be returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 60
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
Required Graph API permissions: Application.Read.All, Directory.Read.All

## RELATED LINKS
