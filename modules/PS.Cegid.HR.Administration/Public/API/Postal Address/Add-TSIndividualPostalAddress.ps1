function Add-TSIndividualPostalAddress {
    <#
    .SYNOPSIS
    Add a postal address to an individual.
    
    .DESCRIPTION
    Creates a new postal address entry for an individual.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_POSTALADRESS
    
    .PARAMETER UserName
    The username of the individual.
    
    .PARAMETER AddressData
    Hashtable containing address data.
    
    .EXAMPLE
    Add-TSIndividualPostalAddress -UserName "jdoe" -AddressData @{ addressLine1 = "123 Main St"; city = "Copenhagen"; postalCode = "1000"; country = "Denmark" }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSPostalAddress])]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [hashtable]
        $AddressData
    )
    
    Write-Verbose "[Add-TSIndividualPostalAddress] Adding postal address to individual $UserName"
    Write-Debug "[Add-TSIndividualPostalAddress] Address data: $($AddressData | ConvertTo-Json)"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName", "Add postal address")) {
        try {
            $body = $AddressData | ConvertTo-Json
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/postal-addresses" -Method "POST" -Body @{ json = $body }
            Write-Verbose "[Add-TSIndividualPostalAddress] Successfully added address"
            Write-Debug "[Add-TSIndividualPostalAddress] Added address: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Add-TSIndividualPostalAddress] Failed to add address: $_"
            throw
        }
    }
}