function Get-TSIndividual {
    <#
    .SYNOPSIS
    Get an individual by username.
    
    .DESCRIPTION
    Retrieves detailed individual information.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_INDIVIDUAL
    
    .PARAMETER UserName
    The username of the individual.
    
    .EXAMPLE
    Get-TSIndividual -UserName "jdoe"
    #>
    [CmdletBinding()]
    [OutputType([TSIndividual])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $UserName
    )
    
    process {
        Write-Verbose "[Get-TSIndividual] Retrieving individual: $UserName"
        
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName" -Method "GET"
            Write-Verbose "[Get-TSIndividual] Successfully retrieved individual $UserName"
            Write-Debug "[Get-TSIndividual] Individual data: $($response | ConvertTo-Json -Depth 2 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSIndividual] Failed to retrieve individual: $_"
            throw
        }
    }
}