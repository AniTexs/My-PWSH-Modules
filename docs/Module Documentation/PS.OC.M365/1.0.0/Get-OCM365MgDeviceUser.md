---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365MgDeviceUser

## SYNOPSIS
Resolves the Microsoft 365 user associated with a device.

## SYNTAX

### Default (Default)
```
Get-OCM365MgDeviceUser -DeviceId <Guid> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### InputObject
```
Get-OCM365MgDeviceUser -Device <MicrosoftGraphDevice> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Intune
```
Get-OCM365MgDeviceUser -ManagedDeviceId <Guid> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Managed
```
Get-OCM365MgDeviceUser -Id <Guid> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Looks up the matching Intune managed device and Windows Autopilot device for an
Entra device, then returns the best available \`UserPrincipalName\` together with
the resolved Microsoft Graph user object.

## EXAMPLES

### EXAMPLE 1
```
Get-MgDevice -Search 'displayName:PC01' -ConsistencyLevel eventual | Get-OCM365MgDeviceUser
```

### EXAMPLE 2
```
Get-OCM365MgDeviceUser -DeviceId '11111111-1111-1111-1111-111111111111'
```

## PARAMETERS

### -Device
A Microsoft Graph device object.

```yaml
Type: MicrosoftGraphDevice
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -DeviceId
The Entra device \`deviceId\` value.

```yaml
Type: Guid
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ManagedDeviceId
The Intune managed device id, for example from an Autopilot device's
\`ManagedDeviceId\` property.

```yaml
Type: Guid
Parameter Sets: Intune
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
The Intune managed device \`Id\` value.

```yaml
Type: Guid
Parameter Sets: Managed
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
