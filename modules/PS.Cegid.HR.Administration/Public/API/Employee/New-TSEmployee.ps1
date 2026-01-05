function New-TSEmployee {
    <#
    .SYNOPSIS
    Create a new employee.
    
    .DESCRIPTION
    Creates a new employee record with individual and user information.
    Requires permission: ADM_USERSACCOUNT_CREATE
    
    .PARAMETER EmployeeData
    Hashtable containing employee creation data.
    
    .EXAMPLE
    $employeeData = @{
        employeeNumber = 12345
        hiringDate = "2025-01-01"
        individual = @{
            firstName = "John"
            lastName = "Doe"
            sex = "M"
            user = @{
                userName = "jdoe"
                email = "jdoe@example.com"
            }
        }
    }
    New-TSEmployee -EmployeeData $employeeData
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSEmployee])]
    param (
        [Parameter(Mandatory)]
        [hashtable]
        $EmployeeData
    )
    
    Write-Verbose "[New-TSEmployee] Creating new employee"
    Write-Debug "[New-TSEmployee] Employee data: $($EmployeeData | ConvertTo-Json -Depth 5)"
    
    if ($PSCmdlet.ShouldProcess("Employee $($EmployeeData.employeeNumber)", "Create")) {
        try {
            $body = $EmployeeData | ConvertTo-Json -Depth 10
            $response = Invoke-TSApi -Path "/directory/employees" -Method "POST" -Body @{ json = $body }
            Write-Verbose "[New-TSEmployee] Successfully created employee"
            return $response
        }
        catch {
            Write-Debug "[New-TSEmployee] Failed to create employee: $_"
            throw
        }
    }
}