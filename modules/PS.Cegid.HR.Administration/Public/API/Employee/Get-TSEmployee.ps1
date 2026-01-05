function Get-TSEmployee {
    <#
    .SYNOPSIS
    Get an employee by employee number.
    
    .DESCRIPTION
    Retrieves detailed employee information including individual data, user account, and associated metadata.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_EMPLOYEE
    
    .PARAMETER EmployeeNumber
    The employee number to retrieve.
    
    .EXAMPLE
    Get-TSEmployee -EmployeeNumber 11011
    
    .EXAMPLE
    11011, 11557 | Get-TSEmployee
    #>
    [CmdletBinding()]
    [OutputType([TSEmployee])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    begin {
        Write-Verbose "[Get-TSEmployee] Starting employee retrieval process"
    }
    
    process {
        Write-Debug "[Get-TSEmployee] Retrieving employee: $EmployeeNumber"
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber" -Method "GET"
            Write-Verbose "[Get-TSEmployee] Successfully retrieved employee $EmployeeNumber"
            Write-Debug "[Get-TSEmployee] Employee data: $($response | ConvertTo-Json -Depth 2 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployee] Failed to retrieve employee $EmployeeNumber : $_"
            throw
        }
    }
    
    end {
        Write-Verbose "[Get-TSEmployee] Completed employee retrieval"
    }
}