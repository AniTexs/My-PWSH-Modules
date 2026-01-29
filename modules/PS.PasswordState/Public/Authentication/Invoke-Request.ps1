function Invoke-Request {
    [CmdletBinding(DefaultParameterSetName = 'WithContext')]
    param (
        [Parameter(ParameterSetName = 'WithoutContext',Mandatory)]
        [string]
        $BaseUrl,
        [Parameter(ParameterSetName = 'WithoutContext',Mandatory)]
        [Parameter(ParameterSetName = 'WithContext',Mandatory)]
        [string]
        $Endpoint,
        [Parameter(ParameterSetName = 'WithoutContext',Mandatory)]
        [string]
        $ApiKey,
        [Parameter(ParameterSetName = 'WithoutContext',Mandatory)]
        [bool]
        $VerifySsl = $true,
        [Parameter(ParameterSetName = 'WithoutContext')]
        [Parameter(ParameterSetName = 'WithContext')]
        [hashtable]
        $Query
    )
    switch ($PSCmdlet.ParameterSetName) {
        'WithoutContext' {
            $ctx = @{
                BaseUrl = $BaseUrl
                ApiKey  = $ApiKey
                TimeoutSec = 30
                VerifySsl  = $VerifySsl
            }
            return Invoke-PWSTRequest -Method 'GET' -Path $Endpoint -Query $Query -Context $ctx
        }
        Default {}
    }
}