function Get-TSIndividuals {
    <#
    .SYNOPSIS
    Get all individuals with pagination.
    
    .DESCRIPTION
    Retrieves a paginated list of all individuals.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_INDIVIDUAL
    
    .PARAMETER Count
    Maximum number of individuals to return.
    
    .PARAMETER Offset
    Number of records to skip.
    
    .PARAMETER ModifiedAfterDate
    Only return individuals modified after this date.
    
    .EXAMPLE
    Get-TSIndividuals -Count 100 -Offset 0
    #>
    [CmdletBinding()]
    [OutputType([TSPaginatedResult])]
    param (
        [Parameter()]
        [int]
        $Count = 100,
        
        [Parameter()]
        [int]
        $Offset = 0,
        
        [Parameter()]
        [datetime]
        $ModifiedAfterDate
    )
    
    Write-Verbose "[Get-TSIndividuals] Retrieving individuals - Count: $Count, Offset: $Offset"
    Write-Debug "[Get-TSIndividuals] ModifiedAfterDate: $ModifiedAfterDate"
    
    $query = @{
        count  = $Count
        offset = $Offset
    }
    
    if ($ModifiedAfterDate) {
        $query['modifiedAfterDate'] = $ModifiedAfterDate.ToString("yyyy-MM-ddTHH:mm:ssZ")
        Write-Debug "[Get-TSIndividuals] Filtering by modification date: $($query['modifiedAfterDate'])"
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/individuals" -Method "GET" -Query $query
        Write-Verbose "[Get-TSIndividuals] Retrieved $($response.items.Count) individuals (Total: $($response.total))"
        Write-Debug "[Get-TSIndividuals] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSIndividuals] Failed to retrieve individuals: $_"
        throw
    }
}