---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# Get-VaultWardenFingerprint

## SYNOPSIS
Retrieves the fingerprint phrase for a user.

## SYNTAX

```
Get-VaultWardenFingerprint [[-UserId] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns the fingerprint phrase for a given user.
The fingerprint phrase is used
to verify a user's identity before confirming organization membership.

## EXAMPLES

### EXAMPLE 1
```
Get-VaultWardenFingerprint
```

### EXAMPLE 2
```
Get-VaultWardenFingerprint -UserId 'some-user-uuid'
```

## PARAMETERS

### -UserId
The UUID of the user to look up.
Defaults to 'me' for the authenticated user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Me
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

### System.String
## NOTES

## RELATED LINKS
