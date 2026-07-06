---
external help file: PS.VaultWarden-help.xml
Module Name: PS.VaultWarden
online version:
schema: 2.0.0
---

# Get-VaultWardenItem

## SYNOPSIS
Retrieves a single vault item or a filtered list of vault items.

## SYNTAX

### List (Default)
```
Get-VaultWardenItem [-Search <String>] [-FolderId <String>] [-CollectionId <String>] [-OrganizationId <String>]
 [-Url <String>] [-Trash] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Single
```
Get-VaultWardenItem [-Id] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
When -Id is provided, returns a single item by its UUID or search term (bw get item).
Without -Id, returns all items matching the supplied filters (bw list items).

## EXAMPLES

### EXAMPLE 1
```
Get-VaultWardenItem -Id 'abc123'
```

### EXAMPLE 2
```
Get-VaultWardenItem -Search 'github'
```

### EXAMPLE 3
```
Get-VaultWardenItem -Search 'github' -FolderId 'null'
```

## PARAMETERS

### -Id
UUID or search term for a single item.

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

### -Search
Searches items by string.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderId
Filters items by folder UUID.
Pass 'null' for items with no folder assignment.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionId
Filters items by collection UUID.
Pass 'null' for items with no collection assignment.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OrganizationId
Filters items by organization UUID.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Filters items matching a specific URI.

```yaml
Type: String
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Trash
Returns items currently in the trash.

```yaml
Type: SwitchParameter
Parameter Sets: List
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
