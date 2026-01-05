function Get-TSEmployeeManagees {
    <#
    .SYNOPSIS
    Get direct reports for an employee.
    
    .DESCRIPTION
    Retrieves the employee's direct reports in the default organization.
    Requires permission: TSGLOBAL_MYPROFILEOTHER_DISPLAY
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .PARAMETER PageIndex
    Page index for pagination.
    
    .PARAMETER PageSize
    Number of results per page.
    
    .EXAMPLE
    Get-TSEmployeeManagees -EmployeeNumber 11011
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber,
        
        [Parameter()]
        [int]
        $PageIndex = 0,
        
        [Parameter()]
        [int]
        $PageSize = 50
    )
    
    process {
        Write-Verbose "[Get-TSEmployeeManagees] Retrieving managees for employee $EmployeeNumber"
        Write-Debug "[Get-TSEmployeeManagees] PageIndex: $PageIndex, PageSize: $PageSize"
        
        $query = @{
            pageIndex = $PageIndex
            pageSize  = $PageSize
        }
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/organizations/default/managees" -Method "GET" -Query $query
            Write-Verbose "[Get-TSEmployeeManagees] Retrieved $($response.items.Count) managees"
            Write-Debug "[Get-TSEmployeeManagees] Response: $($response | ConvertTo-Json -Depth 1 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployeeManagees] Failed to retrieve managees: $_"
            throw
        }
    }
}