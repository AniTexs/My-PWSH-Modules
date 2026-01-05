function Get-TSIndividualOrganizations {
    <#
    .SYNOPSIS
    Get all organizations for an individual by username.
    
    .DESCRIPTION
    Retrieves all organization assignments for an individual.
    Requires permission: ADM_USERSACCOUNT_DISPLAY_GENERAL_ORGA
    
    .PARAMETER UserName
    The username of the individual.
    
    .EXAMPLE
    Get-TSIndividualOrganizations -UserName "jdoe"
    #>
    [CmdletBinding()]
    [OutputType([TSOrganization[]])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]
        $UserName
    )
    
    process {
        Write-Verbose "[Get-TSIndividualOrganizations] Retrieving organizations for individual $UserName"
        
        try {
            $response = Invoke-TSApi -Path "/directory/individuals/$UserName/organizations" -Method "GET"
            Write-Verbose "[Get-TSIndividualOrganizations] Retrieved $($response.Count) organizations"
            Write-Debug "[Get-TSIndividualOrganizations] Organizations: $($response | ConvertTo-Json -Depth 2 -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSIndividualOrganizations] Failed to retrieve organizations: $_"
            throw
        }
    }
}