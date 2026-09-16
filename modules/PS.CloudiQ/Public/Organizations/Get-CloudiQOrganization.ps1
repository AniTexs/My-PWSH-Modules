function Get-CloudiQOrganization {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [int]
        $Id,
        [Parameter(ParameterSetName = 'List')]
        [string]
        $Search,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $Page = 1,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $PageSize = 15
    )
    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        return Invoke-Api -Path "/organizations/$Id"
    }
    $QueryParams = @{
        Page = $Page
        PageSize = $PageSize
    }
    if($Search){
        $QueryParams.Search = $Search
    }
    (Invoke-Api -Path "/organizations" -Query $QueryParams).Items
}