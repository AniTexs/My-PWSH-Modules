function Get-TSIndividualPostalAddresses {
    <#
    .SYNOPSIS
    Get all postal addresses for an individual.
    
    .DESCRIPTION
    Retrieves all postal addresses for an individual by username.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_POSTALADDRESS
    
    .PARAMETER UserName
    The username of the individual.
    
    .EXAMPLE
    Get-TSIndividualPostalAddresses -UserName "jdoe"
    #>
    [CmdletBinding()]
    [OutputType([TSPostalAddress[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $UserName
    )
    
    process {
        Write-Verbose "[Get-TSIndividualPostalAddresses] Retrieving postal addresses for individual $UserName"
        
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/postal-addresses" -Method "GET"
            Write-Verbose "[Get-TSIndividualPostalAddresses] Retrieved $($response.Count) addresses"
            Write-Debug "[Get-TSIndividualPostalAddresses] Addresses: $($response | ConvertTo-Json -Depth 2 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSIndividualPostalAddresses] Failed to retrieve addresses: $_"
            throw
        }
    }
}