---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# Get-VaultWardenTemplate

## SYNOPSIS
Returns a blank object template for creating vault items, folders, or collections.

## SYNTAX

```
Get-VaultWardenTemplate [-Template] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns the expected JSON structure for the specified object type as a PowerShell object.
Use this as a starting point for New-VaultWardenItem, New-VaultWardenFolder, etc.

## EXAMPLES

### EXAMPLE 1
```
$template = Get-VaultWardenTemplate -Template item
$template.name = 'My Login'
$template.login.username = 'jdoe'
$template.login.password = 'p@ssw0rd'
New-VaultWardenItem -Item $template
```

### EXAMPLE 2
```
Get-VaultWardenTemplate -Template folder
```

## PARAMETERS

### -Template
The template type to retrieve.
Valid values:
  item, item.field, item.login, item.login.uri, item.card,
  item.identity, item.securenote, folder, collection,
  item-collections, org-collection

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
