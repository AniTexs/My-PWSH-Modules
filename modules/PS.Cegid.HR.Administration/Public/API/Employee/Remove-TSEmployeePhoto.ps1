function Remove-TSEmployeePhoto {
    <#
    .SYNOPSIS
    Remove an employee's profile picture.
    
    .DESCRIPTION
    Deletes the profile picture for an employee.
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .EXAMPLE
    Remove-TSEmployeePhoto -EmployeeNumber 11011
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    process {
        Write-Verbose "[Remove-TSEmployeePhoto] Removing photo for employee $EmployeeNumber"
        
        if ($PSCmdlet.ShouldProcess("Employee $EmployeeNumber", "Remove photo")) {
            try {
                $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/photo" -Method "DELETE"
                Write-Verbose "[Remove-TSEmployeePhoto] Successfully removed photo"
                return $response
            }
            catch {
                Write-Debug "[Remove-TSEmployeePhoto] Failed to remove photo: $_"
                throw
            }
        }
    }
}