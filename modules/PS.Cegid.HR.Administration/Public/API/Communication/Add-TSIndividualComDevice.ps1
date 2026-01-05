function Add-TSIndividualComDevice {
    <#
    .SYNOPSIS
    Add a communication device to an individual.
    
    .DESCRIPTION
    Creates a new communication device entry for an individual.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_COMDEVICES
    
    .PARAMETER UserName
    The username of the individual.
    
    .PARAMETER DeviceType
    Type of device (Email, MobilePhone, Phone, Fax, InstantMessenger).
    
    .PARAMETER Value
    The device value (email address, phone number, etc.).
    
    .PARAMETER Label
    Optional label for the device.
    
    .PARAMETER IsPreferred
    Mark as preferred device.
    
    .EXAMPLE
    Add-TSIndividualComDevice -UserName "jdoe" -DeviceType "Email" -Value "john.doe@example.com" -IsPreferred
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSComDevice])]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [ValidateSet("Email", "MobilePhone", "Phone", "Fax", "InstantMessenger")]
        [string]
        $DeviceType,
        
        [Parameter(Mandatory)]
        [string]
        $Value,
        
        [Parameter()]
        [string]
        $Label,
        
        [Parameter()]
        [switch]
        $IsPreferred
    )
    
    Write-Verbose "[Add-TSIndividualComDevice] Adding $DeviceType device to individual $UserName"
    Write-Debug "[Add-TSIndividualComDevice] Value: $Value, Label: $Label, IsPreferred: $($IsPreferred.IsPresent)"
    
    $deviceData = @{
        deviceType  = $DeviceType
        value       = $Value
        isPreferred = $IsPreferred.IsPresent
    }
    
    if ($Label) {
        $deviceData['label'] = $Label
    }
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName", "Add $DeviceType device")) {
        try {
            $body = $deviceData | ConvertTo-Json
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/com-devices" -Method "POST" -Body @{ json = $body }
            Write-Verbose "[Add-TSIndividualComDevice] Successfully added device"
            Write-Debug "[Add-TSIndividualComDevice] Added device: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Add-TSIndividualComDevice] Failed to add device: $_"
            throw
        }
    }
}