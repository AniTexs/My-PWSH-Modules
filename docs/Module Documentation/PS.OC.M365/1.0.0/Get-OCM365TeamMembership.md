---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365TeamMembership

## SYNOPSIS
Retrieves all Microsoft Teams and their memberships.

## SYNTAX

```
Get-OCM365TeamMembership [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets all Teams in the tenant and retrieves detailed membership information for each team.
Returns team information along with member details including user ID, email, and roles.

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365TeamMembership
Retrieves all teams and their members.
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
Requires Microsoft Graph PowerShell module and an active Graph connection.
Required Graph API permissions: Team.ReadBasic.All, TeamMember.Read.All

## RELATED LINKS
