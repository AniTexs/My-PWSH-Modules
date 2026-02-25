---
external help file: PS.OC.M365-help.xml
Module Name: PS.OC.M365
online version:
schema: 2.0.0
---

# Get-OCM365SignInLog

## SYNOPSIS
Retrieves Azure AD sign-in logs for users using batch API requests.

## SYNTAX

```
Get-OCM365SignInLog [[-StartDate] <DateTime>] [[-ExcludeUPNDomains] <String[]>] [[-UserFilter] <String[]>]
 [[-BatchSize] <Int32>] [[-MaxRetryAttempts] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Gets sign-in audit logs from Azure AD for specified users or all member users.
Uses Microsoft Graph batch API for efficient retrieval of large numbers of user sign-in logs.
Implements rate limiting handling and retry logic with exponential backoff.

## EXAMPLES

### EXAMPLE 1
```
Get-OCM365SignInLog
Retrieves sign-in logs for all member users for the last 6 months.
```

### EXAMPLE 2
```
Get-OCM365SignInLog -StartDate (Get-Date).AddMonths(-3) -ExcludeUPNDomains @("external.com")
Retrieves sign-in logs for the last 3 months, excluding users from external.com domain.
```

## PARAMETERS

### -StartDate
The start date for filtering sign-in logs.
Defaults to 6 months ago.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Date).AddMonths(-6)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeUPNDomains
Array of UPN domains to exclude from the query.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserFilter
OData filter for querying users.
Defaults to "userType eq 'member'".

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @("userType eq 'member'")
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Number of users to process in each batch.
Default is 20.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxRetryAttempts
Maximum number of retry attempts for rate-limited requests.
Default is 5.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 5
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
Requires Microsoft Graph PowerShell module and an active Graph connection.
Required Graph API permissions: AuditLog.Read.All, User.Read.All

## RELATED LINKS
