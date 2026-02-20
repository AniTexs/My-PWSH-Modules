function New-GraphBatchRequest {
    <#
    .SYNOPSIS
        Creates a batch request object for Microsoft Graph API.

    .DESCRIPTION
        Constructs a properly formatted batch request object containing id, method, and url.

    .PARAMETER Id
        Unique identifier for this request within the batch.

    .PARAMETER Url
        The relative URL for the Graph API endpoint.

    .PARAMETER Method
        HTTP method to use. Default is GET.

    .EXAMPLE
        New-GraphBatchRequest -Id "req1" -Url "/users/user@domain.com" -Method GET

    .NOTES
        This is a private helper function for use within the PS.OC.M365 module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Id,
        
        [Parameter(Mandatory)]
        [string]$Url,
        
        [Parameter()]
        [string]$Method = "GET"
    )
    
    return @{
        id     = $Id
        method = $Method
        url    = $Url
    }
}
