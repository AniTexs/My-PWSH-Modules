function Search-TSEmployee {
    <#
    .SYNOPSIS
    Search for employees by search term.
    
    .DESCRIPTION
    Performs a text search across employee records.
    Requires permission: TSGLOBAL_POPULATIONREQUESTER_SEARCH
    
    .PARAMETER SearchTerm
    The text to search for.
    
    .PARAMETER PageIndex
    The page index for pagination.
    
    .PARAMETER PageSize
    Number of results per page.
    
    .PARAMETER IncludeInactives
    Include inactive employees in results.
    
    .PARAMETER OnlyEmployees
    Only return employees (exclude other individual types).
    
    .EXAMPLE
    Search-TSEmployee -SearchTerm "John" -PageSize 20
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $SearchTerm,
        
        [Parameter()]
        [int]
        $PageIndex = 0,
        
        [Parameter()]
        [int]
        $PageSize = 50,
        
        [Parameter()]
        [switch]
        $IncludeInactives,
        
        [Parameter()]
        [switch]
        $OnlyEmployees
    )
    
    Write-Verbose "[Search-TSEmployee] Searching for: '$SearchTerm'"
    Write-Debug "[Search-TSEmployee] PageIndex: $PageIndex, PageSize: $PageSize, IncludeInactives: $IncludeInactives, OnlyEmployees: $OnlyEmployees"
    
    $query = @{
        searchTerm        = $SearchTerm
        pageIndex         = $PageIndex
        pageSize          = $PageSize
        includeInactives  = $IncludeInactives.IsPresent
        onlyEmployees     = $OnlyEmployees.IsPresent
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/individualSearch" -Method "GET" -Query $query
        Write-Verbose "[Search-TSEmployee] Found $($response.items.Count) results"
        return $response
    }
    catch {
        Write-Debug "[Search-TSEmployee] Search failed: $_"
        throw
    }
}