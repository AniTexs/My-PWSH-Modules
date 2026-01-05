function Get-TSEmployeePostalAddresses {
    <#
    .SYNOPSIS
    Get all postal addresses for an employee.
    
    .DESCRIPTION
    Retrieves all postal addresses for an employee.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_POSTALADDRESS
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .EXAMPLE
    Get-TSEmployeePostalAddresses -EmployeeNumber 11011
    #>
    [CmdletBinding()]
    [OutputType([TSPostalAddress[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    process {
        Write-Verbose "[Get-TSEmployeePostalAddresses] Retrieving postal addresses for employee $EmployeeNumber"
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/postal-addresses" -Method "GET"
            Write-Verbose "[Get-TSEmployeePostalAddresses] Retrieved $($response.Count) addresses"
            Write-Debug "[Get-TSEmployeePostalAddresses] Addresses: $($response | ConvertTo-Json -Depth 2 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployeePostalAddresses] Failed to retrieve addresses: $_"
            throw
        }
    }
}