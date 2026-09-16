---
external help file: PS.CloudiQ-help.xml
Module Name: PS.CloudiQ
online version:
schema: 2.0.0
---

# Invoke-API

## SYNOPSIS
Sends a request to the REST API.

## SYNTAX

```
Invoke-API [-Path] <String> [[-Domain] <String>] [[-Method] <WebRequestMethod>] [[-Payload] <Object>]
 [[-Query] <Hashtable>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wraps Invoke-RestMethod with session handling and header management for the API.

## EXAMPLES

### EXAMPLE 1
```
Invoke-Api -Path '/organizations/1/device'
```

## PARAMETERS

### -Path
API path to invoke.

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

### -Domain
Base API domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Https://api.crayon.com/api/v1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
HTTP method to use for the request.

```yaml
Type: WebRequestMethod
Parameter Sets: (All)
Aliases:
Accepted values: Default, Get, Head, Post, Put, Delete, Trace, Options, Merge, Patch

Required: False
Position: 3
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -Payload
Hashtable representing the request body.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
Hashtable of query string parameters.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
