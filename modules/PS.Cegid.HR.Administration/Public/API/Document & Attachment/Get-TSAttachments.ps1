function Get-TSAttachments {
    <#
    .SYNOPSIS
    Get metadata for all attachments modified since a given date.
    
    .DESCRIPTION
    Retrieves attachment metadata for documents attached to employees.
    Requires permission: ADM_EXPORT_INDIVIDUALATTACHMENT
    
    .PARAMETER ModifiedSince
    Only return attachments modified after this datetime.
    
    .PARAMETER Limit
    Maximum number of results.
    
    .PARAMETER Offset
    Number of results to skip.
    
    .PARAMETER Include
    Additional data to include.
    
    .EXAMPLE
    Get-TSAttachments -ModifiedSince (Get-Date).AddDays(-7) -Limit 100
    #>
    [CmdletBinding()]
    [OutputType([TSPaginatedResult])]
    param (
        [Parameter(Mandatory)]
        [datetime]
        $ModifiedSince,
        
        [Parameter()]
        [int]
        $Limit = 100,
        
        [Parameter()]
        [int]
        $Offset = 0,
        
        [Parameter()]
        [string[]]
        $Include
    )
    
    Write-Verbose "[Get-TSAttachments] Retrieving attachments modified since $ModifiedSince"
    Write-Debug "[Get-TSAttachments] Limit: $Limit, Offset: $Offset"
    
    $query = @{
        modifiedSince = $ModifiedSince.ToString("yyyy-MM-ddTHH:mm:ssZ")
        limit         = $Limit
        offset        = $Offset
    }
    
    if ($Include) {
        $query['include'] = $Include -join ','
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/attachments/metadata/latest" -Method "GET" -Query $query
        Write-Verbose "[Get-TSAttachments] Retrieved $($response.items.Count) attachments"
        Write-Debug "[Get-TSAttachments] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSAttachments] Failed to retrieve attachments: $_"
        throw
    }
}