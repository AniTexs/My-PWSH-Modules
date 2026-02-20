function Invoke-GraphBatchRequest {
    <#
    .SYNOPSIS
        Executes a batch request to Microsoft Graph API.

    .DESCRIPTION
        Sends multiple Graph API requests in a single batch call for improved performance.

    .PARAMETER Requests
        Array of request objects to batch. Each request should have id, method, and url properties.

    .EXAMPLE
        $requests = @(
            @{ id = "1"; method = "GET"; url = "/users/user1" }
            @{ id = "2"; method = "GET"; url = "/users/user2" }
        )
        Invoke-GraphBatchRequest -Requests $requests

    .NOTES
        This is a private helper function for use within the PS.OC.M365 module.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [array]$Requests
    )
    
    $batchBody = @{
        requests = $Requests
    } | ConvertTo-Json -Depth 10
    
    try {
        $response = Invoke-MgGraphRequest -Method POST `
            -Uri 'https://graph.microsoft.com/v1.0/$batch' `
            -Body $batchBody `
            -ContentType "application/json"
        
        return $response.responses
    }
    catch {
        Write-Error "Batch request failed: $_"
        return $null
    }
}
