function Remove-TSIndividualPostalAddresses {
    <#
    .SYNOPSIS
    Remove all postal addresses from an individual.
    
    .DESCRIPTION
    Deletes all postal addresses for an individual.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_POSTALADRESS
    
    .PARAMETER UserName
    The username of the individual.
    
    .EXAMPLE
    Remove-TSIndividualPostalAddresses -UserName "jdoe"
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName
    )
    
    Write-Verbose "[Remove-TSIndividualPostalAddresses] Removing all addresses from individual $UserName"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName", "Remove all postal addresses")) {
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/postal-addresses" -Method "DELETE"
            Write-Verbose "[Remove-TSIndividualPostalAddresses] Successfully removed all addresses"
            Write-Debug "[Remove-TSIndividualPostalAddresses] Delete response: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Remove-TSIndividualPostalAddresses] Failed to remove addresses: $_"
            throw
        }
    }
}