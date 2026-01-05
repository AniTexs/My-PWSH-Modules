function Remove-TSIndividual {
    <#
    .SYNOPSIS
    Delete an individual.
    
    .DESCRIPTION
    Deletes an individual by ID.
    Requires permission: TSGLOBAL_WEBSERVICES_USE
    
    .PARAMETER IndividualId
    The individual ID to delete.
    
    .EXAMPLE
    Remove-TSIndividual -IndividualId 12345
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int]
        $IndividualId
    )
    
    process {
        Write-Verbose "[Remove-TSIndividual] Removing individual $IndividualId"
        
        if ($PSCmdlet.ShouldProcess("Individual $IndividualId", "Delete")) {
            try {
                $response = Invoke-TSApi -Path "/directory/individuals/$IndividualId" -Method "DELETE"
                Write-Verbose "[Remove-TSIndividual] Successfully removed individual"
                Write-Debug "[Remove-TSIndividual] Delete response: $($response | ConvertTo-Json -Compress)"
                return $response
            }
            catch {
                Write-Debug "[Remove-TSIndividual] Failed to remove individual: $_"
                throw
            }
        }
    }
}