function Remove-TSIndividualComDevices {
    <#
    .SYNOPSIS
    Remove all communication devices from an individual.
    
    .DESCRIPTION
    Deletes all communication devices for an individual.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_COMDEVICES
    
    .PARAMETER UserName
    The username of the individual.
    
    .EXAMPLE
    Remove-TSIndividualComDevices -UserName "jdoe"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName
    )
    
    Write-Verbose "[Remove-TSIndividualComDevices] Removing all devices from individual $UserName"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName", "Remove all communication devices")) {
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/com-devices" -Method "DELETE"
            Write-Verbose "[Remove-TSIndividualComDevices] Successfully removed all devices"
            Write-Debug "[Remove-TSIndividualComDevices] Delete response: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Remove-TSIndividualComDevices] Failed to remove devices: $_"
            throw
        }
    }
}