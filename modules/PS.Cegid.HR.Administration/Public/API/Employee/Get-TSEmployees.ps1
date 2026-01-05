function Get-TSEmployees {
    <#
    .SYNOPSIS
    Get all employees with pagination support.
    
    .DESCRIPTION
    Retrieves a paginated list of all employees. Optionally filter by modification date.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_EMPLOYEE
    
    .PARAMETER Count
    Maximum number of employees to return per page.
    
    .PARAMETER Offset
    Number of records to skip for pagination.
    
    .PARAMETER ModifiedAfterDate
    Only return employees modified after this date.
    
    .EXAMPLE
    Get-TSEmployees -Count 50 -Offset 0
    
    .EXAMPLE
    Get-TSEmployees -ModifiedAfterDate (Get-Date).AddDays(-7)
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
    
    Write-Verbose "[Get-TSEmployees] Retrieving employees - Count: $Count, Offset: $Offset"
    Write-Debug "[Get-TSEmployees] ModifiedAfterDate: $ModifiedAfterDate"
    
    $query = @{
        count  = $Count
        offset = $Offset
    }
    
    if ($ModifiedAfterDate) {
        $query['modifiedAfterDate'] = $ModifiedAfterDate.ToString("yyyy-MM-ddTHH:mm:ssZ")
        Write-Debug "[Get-TSEmployees] Filtering by modification date: $($query['modifiedAfterDate'])"
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/employees" -Method "GET" -Query $query
        Write-Verbose "[Get-TSEmployees] Retrieved $($response.items.Count) employees (Total: $($response.total))"
        Write-Debug "[Get-TSEmployees] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSEmployees] Failed to retrieve employees: $_"
        throw
    }
}