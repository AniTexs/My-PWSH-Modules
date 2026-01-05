function Get-TSMyEmployeeFile {
    <#
    .SYNOPSIS
    Get the current user's employee file.
    
    .DESCRIPTION
    Retrieves the employee file information for the current authenticated user.
    
    .EXAMPLE
    Get-TSMyEmployeeFile
    #>
    [CmdletBinding()]
    [OutputType([TSEmployeeFileInfo])]
    param ()
    
    Write-Verbose "[Get-TSMyEmployeeFile] Retrieving my employee file"
    
    try {
        $response = Invoke-TSApi -Path "/directory" -Method "GET"
        Write-Verbose "[Get-TSMyEmployeeFile] Successfully retrieved employee file"
        Write-Debug "[Get-TSMyEmployeeFile] Employee file: $($response | ConvertTo-Json -Depth 2 -Compress)"
        return $response
    }
    catch {
        Write-Debug "[Get-TSMyEmployeeFile] Failed to retrieve employee file: $_"
        throw
    }
}