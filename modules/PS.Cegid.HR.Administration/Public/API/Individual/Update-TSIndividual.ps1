function Update-TSIndividual {
    <#
    .SYNOPSIS
    Update an existing individual.
    
    .DESCRIPTION
    Updates individual information.
    Requires permission: ADM_USERSACCOUNT_EDIT_GENERAL_INDIVIDUAL
    
    .PARAMETER UserName
    The username of the individual to update.
    
    .PARAMETER IndividualData
    Hashtable containing update data.
    
    .PARAMETER PartialUpdate
    Use PATCH for partial updates.
    
    .EXAMPLE
    Update-TSIndividual -UserName "jdoe" -IndividualData @{ firstName = "Jane" } -PartialUpdate
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSIndividual])]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [hashtable]
        $IndividualData,
        
        [Parameter()]
        [switch]
        $PartialUpdate
    )
    
    $method = if ($PartialUpdate) { "PATCH" } else { "PUT" }
    Write-Verbose "[Update-TSIndividual] Updating individual $UserName using $method"
    Write-Debug "[Update-TSIndividual] Update data: $($IndividualData | ConvertTo-Json -Depth 5)"
    
    if ($PSCmdlet.ShouldProcess("Individual $UserName", "Update")) {
        try {
            $body = $IndividualData | ConvertTo-Json -Depth 10
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName" -Method $method -Body @{ json = $body }
            Write-Verbose "[Update-TSIndividual] Successfully updated individual"
            Write-Debug "[Update-TSIndividual] Updated individual: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Update-TSIndividual] Failed to update individual: $_"
            throw
        }
    }
}