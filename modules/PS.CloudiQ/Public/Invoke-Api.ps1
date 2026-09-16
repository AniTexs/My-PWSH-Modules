function Invoke-API {
    <#
    .SYNOPSIS
    Sends a request to the REST API.
    .DESCRIPTION
    Wraps Invoke-RestMethod with session handling and header management for the API.
    .PARAMETER Path
    API path to invoke.
    .PARAMETER Session
    Web request session with authentication cookies.
    .PARAMETER Domain
    Base API domain.
    .PARAMETER Method
    HTTP method to use for the request.
    .PARAMETER Payload
    Hashtable representing the request body.
    .PARAMETER Query
    Hashtable of query string parameters.
    .EXAMPLE
    PS> Invoke-Api -Path '/organizations/1/device'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^\/[\w\d\/\-_]+')]
        [string]
        $Path,
        [ValidatePattern('^https:\/\/[\w+\.]+\/api')]
        [string]
        $Domain = "https://api.crayon.com/api/v1",
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = "Get",
        # Accepts hashtable, array or PSCustomObject so PUT/POST bodies serialize correctly
        [object]
        $Payload = $null,
        [hashtable]
        $Query
    )
    if(!$Script:oAuthObject){
        throw 'Not connected to Cloud-iQ. Please run Connect-CloudiQ first.'
    }
    $Headers = @{
        'Content-Type'  = 'application/json'
        'Accept'        = 'application/json'
        'Authorization' = "Bearer $($Script:oAuthObject.access_token)"
    }
    $APIUrlQuery = ""
    if ($null -ne $Query) {
        $APIUrlQuery = Build-Query -Query $Query
    }
    $Params = @{
        Uri     = "$($Domain+$Path+$APIUrlQuery)"
        Method  = $Method
        Headers = $Headers
    }
    if ($null -ne $Payload) {
        # Pre-serialized JSON strings pass through unchanged (e.g. array bodies built with -AsArray)
        $Params.Body = if ($Payload -is [string]) { $Payload } else { $Payload | ConvertTo-Json -Depth 10 }
    }
    Invoke-RestMethod @Params -SkipHttpErrorCheck
}