---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# New-VaultWardenItem

## SYNOPSIS
Creates a new item in the Bitwarden vault.

## SYNTAX

```
New-VaultWardenItem [-Item] <Object> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Accepts a hashtable or PSCustomObject representing the item, JSON-encodes it,
and creates it in the vault.
Use Get-VaultWardenTemplate to obtain the required
object structure for each item type.

Item types: 1 = Login, 2 = Secure Note, 3 = Card, 4 = Identity, 5 = SSH Key

## EXAMPLES

### EXAMPLE 1
```
$template = Get-VaultWardenTemplate -Template item
$template.name = 'My Login'
$template.login.username = 'user@example.com'
$template.login.password = 'p@ssw0rd'
New-VaultWardenItem -Item $template
```

### EXAMPLE 2
```
$template | New-VaultWardenItem
```

## PARAMETERS

### -Item
A hashtable or PSCustomObject representing the vault item to create.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
