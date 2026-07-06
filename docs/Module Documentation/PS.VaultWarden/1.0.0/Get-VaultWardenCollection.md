---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# Get-VaultWardenCollection

## SYNOPSIS
Retrieves all collections accessible to the authenticated user.

## SYNTAX

```
Get-VaultWardenCollection [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns all personal and organization collections regardless of which
organization they belong to.
To scope to a specific organization, use
Get-VaultWardenOrgCollection -OrganizationId instead.

## EXAMPLES

### EXAMPLE 1
```
Get-VaultWardenCollection
```

## PARAMETERS

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
