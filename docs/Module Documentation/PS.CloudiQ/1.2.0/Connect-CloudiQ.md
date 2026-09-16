---
external help file: PS.CloudiQ-help.xml
Module Name: PS.CloudiQ
online version:
schema: 2.0.0
---

# Connect-CloudiQ

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### ByPassEnvironment (Default)
```
Connect-CloudiQ -ClientId <String> -ClientSecret <String> [[-CloudiQUsername] <String>]
 [[-CloudiQPassword] <SecureString>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Credential
```
Connect-CloudiQ -ClientId <String> -ClientSecret <String> [-Credential <PSCredential>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ClientId
{{ Fill ClientId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
{{ Fill ClientSecret Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CloudiQPassword
{{ Fill CloudiQPassword Description }}

```yaml
Type: SecureString
Parameter Sets: ByPassEnvironment
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CloudiQUsername
{{ Fill CloudiQUsername Description }}

```yaml
Type: String
Parameter Sets: ByPassEnvironment
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
{{ Fill Credential Description }}

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
