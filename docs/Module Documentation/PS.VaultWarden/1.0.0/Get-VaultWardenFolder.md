---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# Get-VaultWardenFolder

## SYNOPSIS
Retrieves a single vault folder or a list of all folders.

## SYNTAX

### List (Default)
```
Get-VaultWardenFolder [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-VaultWardenFolder [-Id] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
When -Id is provided, returns a single folder by UUID or search term.
Without -Id, returns all folders in the vault.

## EXAMPLES

### EXAMPLE 1
```
Get-VaultWardenFolder
```

### EXAMPLE 2
```
Get-VaultWardenFolder -Id 'Work'
```

## PARAMETERS

### -Id
UUID or search term for a single folder.

```yaml
Type: String
Parameter Sets: Single
Aliases:

Required: True
Position: 1
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
