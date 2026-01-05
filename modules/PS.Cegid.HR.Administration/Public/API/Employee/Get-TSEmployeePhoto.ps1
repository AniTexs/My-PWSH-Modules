function Get-TSEmployeePhoto {
    <#
    .SYNOPSIS
    Get an employee's profile picture.
    
    .DESCRIPTION
    Retrieves the profile picture for an employee.
    Requires permission: ExportData
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .PARAMETER NamingMethod
    The naming method used (EmployeeNumber or UserName).
    
    .EXAMPLE
    Get-TSEmployeePhoto -EmployeeNumber 11011
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber,
        
        [Parameter()]
        [ValidateSet("EmployeeNumber", "UserName")]
        [string]
        $NamingMethod = "EmployeeNumber"
    )
    
    process {
        Write-Verbose "[Get-TSEmployeePhoto] Retrieving photo for employee $EmployeeNumber"
        Write-Debug "[Get-TSEmployeePhoto] NamingMethod: $NamingMethod"
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/photo/$NamingMethod" -Method "GET"
            Write-Verbose "[Get-TSEmployeePhoto] Successfully retrieved photo"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployeePhoto] Failed to retrieve photo: $_"
            throw
        }
    }
}