function Invoke-PWSTRequest {
    [CmdletBinding(DefaultParameterSetName = 'Hashtable')]
    param (
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
        [string]$Path,
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'PSCmdlet')]
        [Alias('PSCmdlet')]
        [System.Management.Automation.PSCmdlet]
        $Cmdlet, 
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'Hashtable')]
        [Parameter(ValueFromPipeline = $true, ParameterSetName="File",Mandatory)]
        [Hashtable]
        $Query = @{},
        [hashtable]$Body = $null,
        [hashtable]$Context,
        [Parameter(ParameterSetName="File")]
        [System.IO.FileInfo]$File
    )
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    Write-Verbose "PWSTREQUEST:: Invoking PWST Request: $Method $Path"
    if ($Context) {
        $ctx = $Context
    } else {
        $ctx = Get-Context
    }
    switch($PSCmdlet.ParameterSetName){
        'Hashtable' {
            Write-Verbose "PWSTREQUEST:: Building query from hashtable."
            if (-not $Query) { $Query = @{} }
            $Uri = Build-PWSTUri -BaseUrl $ctx.BaseUrl -Endpoint $Path -Query $Query -Context $ctx -Verbose:$PSBoundParameters.Verbose
        }
        'PSCmdlet' {
            Write-Verbose "PWSTREQUEST:: Building query from Cmdlet parameters."
            $Query = Build-QueryFromParams -Cmdlet $Cmdlet
            $Uri = Build-PWSTUri -BaseUrl $ctx.BaseUrl -Endpoint ($Path+$Query) -Context $ctx -Verbose:$PSBoundParameters.Verbose
        }
        'File' {
            Write-Verbose "PWSTREQUEST:: Building query from file."
            if (-not $File) { throw "File parameter is required for File parameter set." }
            if (-not $Query) { $Query = @{} }
            $Uri = Build-PWSTUri -BaseUrl $ctx.BaseUrl -Endpoint $Path -Context $ctx -Query $Query -Verbose:$PSBoundParameters.Verbose
        }
    }
    
    Write-Verbose "PWSTREQUEST:: Request URI: $Uri"
    $Params = @{
        Uri     = $Uri
        Method  = $Method
        ConnectionTimeoutSeconds = ($ctx.TimeoutSec)
        SkipCertificateCheck = (-not $ctx.VerifySsl)
        Header = @{ "APIKey" = $ctx.ApiKey }
    }

    if ($File) {
        $Params.InFile = $File.FullName
        $Params.ContentType = 'multipart/form-data'
    }

    if ($Body) {
        $Params.Body = $Body | ConvertTo-Json -Depth 10
        $Params.ContentType = 'application/json'
    }

    $response = Invoke-RestMethod @Params -SkipHttpErrorCheck
    if($response.errors){
        $Err = $response.errors
        $Details = $Err.phrase
        if($Details -match "\'System Settings\'"){
            $Details = @"
Looks like your API Key does not have sufficient permissions.
- Is this API Key valid?
- Is this a System API Key or a User API Key?

Please ensure the API Key has access to 'System Settings' for this operation.

"@
            Write-Host $Details -ForegroundColor Yellow
        }
        throw "$(($Err.message -join " ").Trim()): $Details"
        return $null
    }else{
        return $response
    }
}