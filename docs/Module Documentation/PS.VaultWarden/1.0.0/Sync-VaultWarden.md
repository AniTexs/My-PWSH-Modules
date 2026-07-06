---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# Sync-VaultWarden

## SYNOPSIS
Synchronizes the local vault cache with the Bitwarden server.

## SYNTAX

```
Sync-VaultWarden [-Last] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Downloads the latest encrypted vault data from the server.
Run this after making
changes in another Bitwarden client (web vault, browser extension, mobile app)
to make those changes available in the CLI session.

## EXAMPLES

### EXAMPLE 1
```
Sync-VaultWarden
```

### EXAMPLE 2
```
Sync-VaultWarden -Last
```

## PARAMETERS

### -Last
When specified, returns the ISO 8601 timestamp of the last successful sync
instead of performing a new sync.

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

## RELATED LINKS
