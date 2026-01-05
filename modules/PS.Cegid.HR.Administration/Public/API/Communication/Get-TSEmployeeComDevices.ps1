function Get-TSEmployeeComDevices {
    <#
    .SYNOPSIS
    Get all communication devices for an employee.
    
    .DESCRIPTION
    Retrieves all communication devices (email, phone, fax, etc.) for an employee.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_COMDEVICES
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .EXAMPLE
    Get-TSEmployeeComDevices -EmployeeNumber 11011
    #>
    [CmdletBinding()]
    [OutputType([TSComDevice[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    process {
        Write-Verbose "[Get-TSEmployeeComDevices] Retrieving communication devices for employee $EmployeeNumber"
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/com-devices" -Method "GET"
            Write-Verbose "[Get-TSEmployeeComDevices] Retrieved $($response.Count) devices"
            Write-Debug "[Get-TSEmployeeComDevices] Devices: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployeeComDevices] Failed to retrieve devices: $_"
            throw
        }
    }
}