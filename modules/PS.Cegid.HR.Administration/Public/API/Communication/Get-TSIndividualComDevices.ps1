function Get-TSIndividualComDevices {
    <#
    .SYNOPSIS
    Get all communication devices for an individual.
    
    .DESCRIPTION
    Retrieves all communication devices for an individual by username.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_COMDEVICES
    
    .PARAMETER UserName
    The username of the individual.
    
    .EXAMPLE
    Get-TSIndividualComDevices -UserName "jdoe"
    #>
    [CmdletBinding()]
    [OutputType([TSComDevice[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $UserName
    )
    
    process {
        Write-Verbose "[Get-TSIndividualComDevices] Retrieving communication devices for individual $UserName"
        
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/com-devices" -Method "GET"
            Write-Verbose "[Get-TSIndividualComDevices] Retrieved $($response.Count) devices"
            Write-Debug "[Get-TSIndividualComDevices] Devices: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSIndividualComDevices] Failed to retrieve devices: $_"
            throw
        }
    }
}