function Update-TSEmployee {
    <#
    .SYNOPSIS
    Update an existing employee.
    
    .DESCRIPTION
    Updates employee information using PUT (full update) or PATCH (partial update).
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_EMPLOYEE
    
    .PARAMETER EmployeeNumber
    The employee number to update.
    
    .PARAMETER EmployeeData
    Hashtable containing employee update data.
    
    .PARAMETER PartialUpdate
    Use PATCH instead of PUT for partial updates.
    
    .EXAMPLE
    Update-TSEmployee -EmployeeNumber 11011 -EmployeeData @{ hiringDate = "2024-01-01" } -PartialUpdate
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSEmployee])]
    param (
        [Parameter(Mandatory)]
        [int]
        $EmployeeNumber,
        
        [Parameter(Mandatory)]
        [hashtable]
        $EmployeeData,
        
        [Parameter()]
        [switch]
        $PartialUpdate
    )
    
    $method = if ($PartialUpdate) { "PATCH" } else { "PUT" }
    Write-Verbose "[Update-TSEmployee] Updating employee $EmployeeNumber using $method"
    Write-Debug "[Update-TSEmployee] Update data: $($EmployeeData | ConvertTo-Json -Depth 5)"
    
    if ($PSCmdlet.ShouldProcess("Employee $EmployeeNumber", "Update")) {
        try {
            $body = $EmployeeData | ConvertTo-Json -Depth 10
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber" -Method $method -Body @{ json = $body }
            Write-Verbose "[Update-TSEmployee] Successfully updated employee $EmployeeNumber"
            return $response
        }
        catch {
            Write-Debug "[Update-TSEmployee] Failed to update employee: $_"
            throw
        }
    }
}