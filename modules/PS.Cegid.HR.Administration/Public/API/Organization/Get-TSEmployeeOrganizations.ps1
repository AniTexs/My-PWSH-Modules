function Get-TSEmployeeOrganizations {
    <#
    .SYNOPSIS
    Get all organizations for an employee.
    
    .DESCRIPTION
    Retrieves all organization assignments for an employee.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_ORGA
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .EXAMPLE
    Get-TSEmployeeOrganizations -EmployeeNumber 11011
    #>
    [CmdletBinding()]
    [OutputType([TSOrganization[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    process {
        Write-Verbose "[Get-TSEmployeeOrganizations] Retrieving organizations for employee $EmployeeNumber"
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/organizations" -Method "GET"
            Write-Verbose "[Get-TSEmployeeOrganizations] Retrieved $($response.Count) organizations"
            Write-Debug "[Get-TSEmployeeOrganizations] Organizations: $($response | ConvertTo-Json -Depth 2 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployeeOrganizations] Failed to retrieve organizations: $_"
            throw
        }
    }
}