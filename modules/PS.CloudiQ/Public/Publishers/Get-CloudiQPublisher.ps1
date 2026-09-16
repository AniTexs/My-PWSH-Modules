function Get-CloudiQPublisher {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [int]
        $Id,
        [Parameter(ParameterSetName = 'List')]
        [string[]]
        $Names,
        [Parameter(ParameterSetName = 'List')]
        [string]
        $Search,
        [Parameter(ParameterSetName = 'List')]
        [int]
        # ProgramType enum: 0, 1, 2, 4
        $ProgramType,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $Page = 1,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $PageSize = 15
    )
    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        return Invoke-Api -Path "/Publishers/$Id"
    }
    $QueryParams = @{
        Page     = $Page
        PageSize = $PageSize
    }
    if ($Names)   { $QueryParams.Names = $Names }
    if ($Search)  { $QueryParams.Search = $Search }
    if ($PSBoundParameters.ContainsKey('ProgramType')) { $QueryParams.ProgramType = $ProgramType }

    (Invoke-Api -Path "/Publishers" -Query $QueryParams).Items
}
