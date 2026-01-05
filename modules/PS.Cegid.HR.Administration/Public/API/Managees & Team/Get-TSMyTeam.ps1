function Get-TSMyTeam {
    <#
    .SYNOPSIS
    Get the current user's team.
    
    .DESCRIPTION
    Retrieves employees with the current user as manager in the default organization.
    
    .PARAMETER OnlyDirectReports
    Only include direct reports.
    
    .PARAMETER Limit
    Maximum number of results.
    
    .PARAMETER Offset
    Number of results to skip.
    
    .PARAMETER Include
    Additional data to include in response.
    
    .EXAMPLE
    Get-TSMyTeam -OnlyDirectReports
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]
        $OnlyDirectReports,
        
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
    
    Write-Verbose "[Get-TSMyTeam] Retrieving my team"
    Write-Debug "[Get-TSMyTeam] OnlyDirectReports: $($OnlyDirectReports.IsPresent), Limit: $Limit, Offset: $Offset"
    
    $query = @{
        onlyDirectReports = $OnlyDirectReports.IsPresent
        limit             = $Limit
        offset            = $Offset
    }
    
    if ($Include) {
        $query['include'] = $Include -join ','
        Write-Debug "[Get-TSMyTeam] Include: $($query['include'])"
    }
    
    try {
        $response = Invoke-TSApi -Path "/directory/employees/my/organization/default/team" -Method "GET" -Query $query
        Write-Verbose "[Get-TSMyTeam] Retrieved $($response.items.Count) team members"
        Write-Debug "[Get-TSMyTeam] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSMyTeam] Failed to retrieve team: $_"
        throw
    }
}