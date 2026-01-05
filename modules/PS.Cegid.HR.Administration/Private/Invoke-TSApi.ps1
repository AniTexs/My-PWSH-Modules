function Invoke-TSApi {
    [CmdletBinding()]
    param (
        [Parameter()]
        [TSApiSession]
        $tsApiSession = $Script:TSApiSession,
        [Parameter(Mandatory)]
        [string]
        $Path,
        [Parameter()]
        [string]
        $Method = "GET",
        [Parameter()]
        [hashtable]
        $Body = @{},
        [Parameter()]
        [hashtable]
        $Query = @{}
    )
    Write-Verbose "[Invoke-TSApi] Starting API invocation"
    Write-Debug "[Invoke-TSApi] Method: $Method"
    Write-Debug "[Invoke-TSApi] Path: $Path"
    Write-Debug "[Invoke-TSApi] Query parameters count: $($Query.Count)"
    Write-Debug "[Invoke-TSApi] Body parameters count: $($Body.Count)"
    
    if (-not $tsApiSession) {
        Write-Debug "[Invoke-TSApi] No session found in parameters or script scope"
        throw "Not connected to Talentsoft. Please run Connect-Talentsoft first."
    }
    
    Write-Verbose "[Invoke-TSApi] Session found - BaseUri: $($tsApiSession.BaseUri)"
    Write-Debug "[Invoke-TSApi] Testing API connection status"
    
    if ((Test-TSApiConnection -tsApiSession $tsApiSession) -eq $false) {
        Write-Verbose "[Invoke-TSApi] Connection test failed - attempting to reconnect"
        Write-Debug "[Invoke-TSApi] Reconnecting with ClientId: $($tsApiSession.ClientId)"
        
        $reconnectedSession = Connect-Talentsoft -BaseUri $tsApiSession.BaseUri -ClientId $tsApiSession.ClientId -ClientSecret $tsApiSession.ClientSecret
        if (-not $reconnectedSession) {
            Write-Debug "[Invoke-TSApi] Reconnection attempt failed"
            throw "Reconnection to Talentsoft failed. Please run Connect-Talentsoft again."
        }
        Write-Verbose "[Invoke-TSApi] Successfully reconnected to Talentsoft"
    }
    else {
        Write-Debug "[Invoke-TSApi] Connection test passed - proceeding with API call"
    }
    
    $ApiUri = $tsApiSession.BaseUri
    Write-Debug "[Invoke-TSApi] Initial ApiUri: $ApiUri"
    
    if ($Path -notlike "/api*") {
        $ApiUri = $ApiUri + "/api"
        Write-Debug "[Invoke-TSApi] Added /api to URI: $ApiUri"
    }
    if ($Path -notlike "/api/v1.0*") {
        $ApiUri = $ApiUri + "/v1.0"
        Write-Debug "[Invoke-TSApi] Added /v1.0 to URI: $ApiUri"
    }
    
    # Build full URI
    $uri = @($ApiUri.TrimEnd('/'), $Path.TrimStart('/')) -join '/'
    Write-Debug "[Invoke-TSApi] Base URI constructed: $uri"
    
    if ($Query.Count -gt 0) {
        Write-Debug "[Invoke-TSApi] Building query string from $($Query.Count) parameters"
        $queryString = Build-TSQuery -Query $Query
        $uri += $queryString
        Write-Debug "[Invoke-TSApi] Query string: $queryString"
    }
    
    Write-Verbose "[Invoke-TSApi] Final URI: $uri"
    Write-Debug "[Invoke-TSApi] Executing $Method request"
    
    try {
        # Prepare parameters for Invoke-RestMethod
        $invokeParams = @{
            Uri                    = $uri
            Method                 = $Method
            WebSession             = $tsApiSession.WebSession
            ContentType            = "application/json"
            ErrorAction            = 'Stop'
            ResponseHeadersVariable = 'responseHeaders'
            StatusCodeVariable      = 'statusCode'
        }

        # Only send a body for methods that typically support it
        $methodsWithBody = @('POST', 'PUT', 'PATCH')
        if ($PSBoundParameters.ContainsKey('Body') -and $null -ne $Body -and $methodsWithBody -contains $Method.ToUpperInvariant()) {
            Write-Debug "[Invoke-TSApi] Adding request body for $Method request"
            $invokeParams.Body = $Body
        }

        $response = Invoke-RestMethod @invokeParams
        Write-Verbose "[Invoke-TSApi] API call successful"
        Write-Debug "[Invoke-TSApi] Response received - Status Code: $statusCode"
        if ($null -ne $responseHeaders) {
            Write-Debug ("[Invoke-TSApi] Response headers:`n{0}" -f ($responseHeaders | Out-String))
        }
        Write-Debug "[Invoke-TSApi] Response received successfully"
    }
    catch {
        # Get the actual exception type for debugging
        $ExceptionType = $_.Exception.GetType().FullName
        Write-Debug "[Invoke-TSApi] Exception type: $ExceptionType"
        
        $Err = $Error[0]
        $HttpErrorCode = $null
        
        # Try to get HTTP status code from various possible locations
        if ($_.Exception.Response) {
            $HttpErrorCode = $_.Exception.Response.StatusCode
            Write-Debug "[Invoke-TSApi] HTTP Status Code from Response: $HttpErrorCode"
        }
        elseif ($_.Exception.StatusCode) {
            $HttpErrorCode = $_.Exception.StatusCode
            Write-Debug "[Invoke-TSApi] HTTP Status Code from StatusCode property: $HttpErrorCode"
        }
        
        if ($HttpErrorCode) {
            Write-Debug "[Invoke-TSApi] HTTP error caught - Status Code: $HttpErrorCode"
            Write-Verbose "[Invoke-TSApi] Handling HTTP exception: $HttpErrorCode"

            switch ($HttpErrorCode) {
                401 {
                    Write-Debug "[Invoke-TSApi] 401 Unauthorized error detected"
                    # Convert from json to hashtable
                    $ResponseMessage = $Err.ErrorDetails.Message | ConvertFrom-Json
                    Write-Debug "[Invoke-TSApi] Error message: $($ResponseMessage.message)"
                
                    switch ($ResponseMessage.message) {
                        'User is not authenticated' {
                            Write-Verbose "[Invoke-TSApi] User not authenticated - re-authenticating"
                            Write-Debug "[Invoke-TSApi] Calling Connect-Talentsoft for re-authentication"
                        
                            # Re-authenticate
                            Connect-Talentsoft -BaseUri $tsApiSession.BaseUri -ClientId $tsApiSession.ClientId -ClientSecret $tsApiSession.ClientSecret
                        
                            Write-Debug "[Invoke-TSApi] Retrying original request after re-authentication"
                            # Retry the request
                            $response = Invoke-RestMethod -Uri $uri -Method $Method -Body $Body -WebSession $tsApiSession.WebSession -ContentType "application/json" -ErrorAction Stop -ResponseHeadersVariable responseHeaders -StatusCodeVariable statusCode
                            Write-Verbose "[Invoke-TSApi] Retry successful after re-authentication"
                        }
                        Default {
                            Write-Debug "[Invoke-TSApi] Unhandled 401 message: $($ResponseMessage.Message)"
                            throw "Unauthorized: $($ResponseMessage.Message)"
                        }
                    }
                }
                403 {
                    Write-Debug "[Invoke-TSApi] 403 Forbidden error detected"
                    $ErrorMessage = "Access Forbidden: You do not have permission to access this resource."
                    $ApiMessage = $null
                
                    if ($Err.ErrorDetails.Message) {
                        try {
                            $ResponseMessage = $Err.ErrorDetails.Message | ConvertFrom-Json
                            Write-Debug "[Invoke-TSApi] Forbidden error details: $($ResponseMessage | ConvertTo-Json -Depth 5)"
                            if ($ResponseMessage.message) {
                                $ApiMessage = $ResponseMessage.message
                            }
                        }
                        catch {
                            Write-Debug "[Invoke-TSApi] Could not parse error response as JSON"
                        }
                    }
                    
                    # Build detailed error message
                    $DetailedError = @(
                        $ErrorMessage
                        "  Resource: $uri"
                        "  Status Code: 403 Forbidden"
                    )
                    if ($ApiMessage) {
                        $DetailedError += "  API Message: $ApiMessage"
                    }
                    $FinalError = $DetailedError -join "`n"
                
                    Write-Verbose "[Invoke-TSApi] $FinalError"
                    throw $FinalError
                }
                404 {
                    Write-Debug "[Invoke-TSApi] 404 Not Found error detected"
                    $ErrorMessage = "Resource Not Found: The requested resource does not exist."
                    $ApiMessage = $null
                
                    if ($Err.ErrorDetails.Message) {
                        try {
                            $ResponseMessage = $Err.ErrorDetails.Message | ConvertFrom-Json
                            Write-Debug "[Invoke-TSApi] Not Found error details: $($ResponseMessage | ConvertTo-Json -Depth 5)"
                            if ($ResponseMessage.message) {
                                $ApiMessage = $ResponseMessage.message
                            }
                        }
                        catch {
                            Write-Debug "[Invoke-TSApi] Could not parse error response as JSON"
                        }
                    }
                    
                    # Build detailed error message
                    $DetailedError = @(
                        $ErrorMessage
                        "  Resource: $uri"
                        "  Status Code: 404 Not Found"
                    )
                    if ($ApiMessage) {
                        $DetailedError += "  API Message: $ApiMessage"
                    }
                    $FinalError = $DetailedError -join "`n"
                
                    Write-Verbose "[Invoke-TSApi] $FinalError"
                    throw $FinalError
                }
                Default {
                    Write-Debug "[Invoke-TSApi] Unhandled HTTP error code: $HttpErrorCode"
                    $ErrorMessage = "HTTP $HttpErrorCode Error: API request failed."
                    $ApiMessage = $null
                    $RawDetails = $null
                
                    if ($Err.ErrorDetails.Message) {
                        try {
                            $ResponseMessage = $Err.ErrorDetails.Message | ConvertFrom-Json
                            Write-Debug "[Invoke-TSApi] Error response: $($ResponseMessage | ConvertTo-Json -Depth 5)"
                            if ($ResponseMessage.message) {
                                $ApiMessage = $ResponseMessage.message
                            }
                            else {
                                $RawDetails = $Err.ErrorDetails.Message
                            }
                        }
                        catch {
                            $RawDetails = $Err.ErrorDetails.Message
                            Write-Debug "[Invoke-TSApi] Raw error message: $($Err.ErrorDetails.Message)"
                        }
                    }
                    
                    # Build detailed error message
                    $DetailedError = @(
                        $ErrorMessage
                        "  Resource: $uri"
                        "  Status Code: $HttpErrorCode"
                    )
                    if ($ApiMessage) {
                        $DetailedError += "  API Message: $ApiMessage"
                    }
                    elseif ($RawDetails) {
                        $DetailedError += "  Details: $RawDetails"
                    }
                    $FinalError = $DetailedError -join "`n"
                
                    Write-Verbose "[Invoke-TSApi] $FinalError"
                    throw $FinalError
                }
            }
        }
        else {
            # No HTTP status code found - might be a different type of error
            Write-Debug "[Invoke-TSApi] No HTTP status code found"
            Write-Debug "[Invoke-TSApi] Exception message: $($_.Exception.Message)"
            Write-Verbose "[Invoke-TSApi] API call failed with non-HTTP error"
            throw "Error invoking TS API: $_"
        }
    }
    
    Write-Debug "[Invoke-TSApi] Returning response"
    return $response
}