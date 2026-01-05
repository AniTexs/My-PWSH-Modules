function Get-TSMyManagees {
    <#
    .SYNOPSIS
    Get the current user's direct reports.
    
    .DESCRIPTION
    Retrieves employees with the current user as manager in the default organization.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_ORGA
    
    .PARAMETER PageIndex
    Page index for pagination.
    
    .PARAMETER PageSize
    Number of results per page.
    
    .EXAMPLE
    Get-TSMyManagees -PageSize 50
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $PageIndex = 0,
        
        [Parameter()]
        [int]
        $PageSize = 50
    )
    
    Write-Verbose "[Get-TSMyManagees] Retrieving my managees"
    Write-Debug "[Get-TSMyManagees] PageIndex: $PageIndex, PageSize: $PageSize"
    
    $query = @{
        pageIndex = $PageIndex
        pageSize  = $PageSize
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/my/organization/managees" -Method "GET" -Query $query
        Write-Verbose "[Get-TSMyManagees] Retrieved $($response.items.Count) managees"
        Write-Debug "[Get-TSMyManagees] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSMyManagees] Failed to retrieve managees: $_"
        throw
    }
}