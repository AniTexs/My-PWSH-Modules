function Get-TSMyColleagues {
    <#
    .SYNOPSIS
    Get colleagues with the same manager.
    
    .DESCRIPTION
    Retrieves employees with the same manager as the current user in the default organization.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_ORGA
    
    .PARAMETER PageIndex
    Page index for pagination.
    
    .PARAMETER PageSize
    Number of results per page.
    
    .EXAMPLE
    Get-TSMyColleagues -PageSize 50
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
    
    Write-Verbose "[Get-TSMyColleagues] Retrieving my colleagues"
    Write-Debug "[Get-TSMyColleagues] PageIndex: $PageIndex, PageSize: $PageSize"
    
    $query = @{
        pageIndex = $PageIndex
        pageSize  = $PageSize
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/my/organization/colleagues" -Method "GET" -Query $query
        Write-Verbose "[Get-TSMyColleagues] Retrieved $($response.items.Count) colleagues"
        Write-Debug "[Get-TSMyColleagues] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSMyColleagues] Failed to retrieve colleagues: $_"
        throw
    }
}