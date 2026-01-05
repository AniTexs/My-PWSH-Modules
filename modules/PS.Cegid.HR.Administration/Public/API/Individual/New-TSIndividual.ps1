function New-TSIndividual {
    <#
    .SYNOPSIS
    Create a new individual.
    
    .DESCRIPTION
    Creates a new individual record.
    Requires permission: ADM_USERSACCOUNT_CREATE
    
    .PARAMETER IndividualData
    Hashtable containing individual creation data.
    
    .EXAMPLE
    New-TSIndividual -IndividualData @{ firstName = "John"; lastName = "Doe"; user = @{ userName = "jdoe"; email = "jdoe@example.com" } }
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([TSIndividual])]
    param (
        [Parameter(Mandatory)]
        [hashtable]
        $IndividualData
    )
    
    Write-Verbose "[New-TSIndividual] Creating new individual"
    Write-Debug "[New-TSIndividual] Data: $($IndividualData | ConvertTo-Json -Depth 5)"
    
    if ($PSCmdlet.ShouldProcess("Individual $($IndividualData.userName)", "Create")) {
        try {
            $body = $IndividualData | ConvertTo-Json -Depth 10
            $response = Invoke-TSApi -Path "/directory/individuals" -Method "POST" -Body @{ json = $body }
            Write-Verbose "[New-TSIndividual] Successfully created individual"
            Write-Debug "[New-TSIndividual] Created individual: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[New-TSIndividual] Failed to create individual: $_"
            throw
        }
    }
}