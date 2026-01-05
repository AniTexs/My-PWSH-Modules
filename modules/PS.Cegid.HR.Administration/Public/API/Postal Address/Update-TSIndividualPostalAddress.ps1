function Update-TSIndividualPostalAddress {
    <#
    .SYNOPSIS
    Update a postal address for an individual.
    
    .DESCRIPTION
    Updates an existing postal address by rank.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_POSTALADRESS
    
    .PARAMETER UserName
    The username of the individual.
    
    .PARAMETER Rank
    The address rank to update.
    
    .PARAMETER AddressData
    Updated address data.
    
    .EXAMPLE
    Update-TSIndividualPostalAddress -UserName "jdoe" -Rank 1 -AddressData @{ city = "Aarhus" }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSPostalAddress])]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [int]
        $Rank,
        
        [Parameter(Mandatory)]
        [hashtable]
        $AddressData
    )
    
    Write-Verbose "[Update-TSIndividualPostalAddress] Updating address rank $Rank for individual $UserName"
    Write-Debug "[Update-TSIndividualPostalAddress] Update data: $($AddressData | ConvertTo-Json)"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName - Address $Rank", "Update")) {
        try {
            $body = $AddressData | ConvertTo-Json
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/postal-addresses/$Rank" -Method "PUT" -Body @{ json = $body }
            Write-Verbose "[Update-TSIndividualPostalAddress] Successfully updated address"
            Write-Debug "[Update-TSIndividualPostalAddress] Updated address: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Update-TSIndividualPostalAddress] Failed to update address: $_"
            throw
        }
    }
}