---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# New-VaultWardenPassword

## SYNOPSIS
Generates a strong random password or passphrase.

## SYNTAX

### Password (Default)
```
New-VaultWardenPassword [-Length <Int32>] [-Uppercase] [-Lowercase] [-Number] [-Special]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Passphrase
```
New-VaultWardenPassword [-Passphrase] [-Words <Int32>] [-Separator <String>] [-Capitalize] [-IncludeNumber]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps the Bitwarden CLI 'generate' command.
By default generates a 14-character
password with uppercase, lowercase, and numbers.

## EXAMPLES

### EXAMPLE 1
```
New-VaultWardenPassword
```

### EXAMPLE 2
```
New-VaultWardenPassword -Length 20 -Uppercase -Lowercase -Number -Special
```

### EXAMPLE 3
```
New-VaultWardenPassword -Passphrase -Words 4 -Capitalize
```

## PARAMETERS

### -Length
Length of the generated password.
Minimum 5.
Default 14.

```yaml
Type: Int32
Parameter Sets: Password
Aliases:

Required: False
Position: Named
Default value: 14
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uppercase
Include uppercase letters.

```yaml
Type: SwitchParameter
Parameter Sets: Password
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Lowercase
Include lowercase letters.

```yaml
Type: SwitchParameter
Parameter Sets: Password
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Number
Include numbers.

```yaml
Type: SwitchParameter
Parameter Sets: Password
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Special
Include special characters.

```yaml
Type: SwitchParameter
Parameter Sets: Password
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Passphrase
Generate a passphrase instead of a password.

```yaml
Type: SwitchParameter
Parameter Sets: Passphrase
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Words
Number of words in the passphrase.
Used with -Passphrase.
Default 3.

```yaml
Type: Int32
Parameter Sets: Passphrase
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -Separator
Word separator character.
Used with -Passphrase.
Default '-'.

```yaml
Type: String
Parameter Sets: Passphrase
Aliases:

Required: False
Position: Named
Default value: -
Accept pipeline input: False
Accept wildcard characters: False
```

### -Capitalize
Title-case the passphrase words.
Used with -Passphrase.

```yaml
Type: SwitchParameter
Parameter Sets: Passphrase
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeNumber
Include a single number in the passphrase.
Used with -Passphrase.

```yaml
Type: SwitchParameter
Parameter Sets: Passphrase
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

### System.String
## NOTES

## RELATED LINKS
