function Get-TSEmployeePhotoMetadata {
    <#
    .SYNOPSIS
    Get employee photo metadata.
    
    .DESCRIPTION
    Retrieves metadata about an employee's profile picture without downloading the actual image.
    Requires permission: TSGLOBAL_MYPROFILEOTHER_DISPLAY
    
    .PARAMETER EmployeeNumber
    The employee number.
    
    .EXAMPLE
    Get-TSEmployeePhotoMetadata -EmployeeNumber 11011
    #>
    [CmdletBinding()]
    [OutputType([TSPhotoMetadata])]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    process {
        Write-Verbose "[Get-TSEmployeePhotoMetadata] Retrieving photo metadata for employee $EmployeeNumber"
        
        try {
            $response = Invoke-TSApi -Path "/directory/employees/$EmployeeNumber/photo/metadata" -Method "GET"
            Write-Verbose "[Get-TSEmployeePhotoMetadata] Successfully retrieved metadata"
            Write-Debug "[Get-TSEmployeePhotoMetadata] Metadata: $($response | ConvertTo-Json -Compress)"
            return $response
        }
        catch {
            Write-Debug "[Get-TSEmployeePhotoMetadata] Failed to retrieve metadata: $_"
            throw
        }
    }
}