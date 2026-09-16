function Get-CloudiQCustomerTenant {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [int]
        $Id,
        [Parameter(ParameterSetName = 'ById')]
        [switch]
        # Return the detailed customer tenant representation
        $Detailed,
        [Parameter(Mandatory, ParameterSetName = 'List')]
        [int]
        $OrganizationId,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $PublisherId,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $ProgramId,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $ConsumerId,
        [Parameter(ParameterSetName = 'List')]
        [string]
        $Domain,
        [Parameter(ParameterSetName = 'List')]
        [string]
        $DomainPrefix,
        [Parameter(ParameterSetName = 'List')]
        [int]
        # CustomerTenantType enum: 0, 1, 2
        $CustomerTenantType,
        [Parameter(ParameterSetName = 'List')]
        [int]
        $InvoiceProfileId,
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
        $Path = if ($Detailed) { "/CustomerTenants/$Id/detailed" } else { "/CustomerTenants/$Id" }
        return Invoke-Api -Path $Path
    }
    $QueryParams = @{
        OrganizationId = $OrganizationId
        Page           = $Page
        PageSize       = $PageSize
    }
    if ($PublisherId)      { $QueryParams.PublisherId = $PublisherId }
    if ($ProgramId)        { $QueryParams.ProgramId = $ProgramId }
    if ($ConsumerId)       { $QueryParams.ConsumerId = $ConsumerId }
    if ($Domain)           { $QueryParams.Domain = $Domain }
    if ($DomainPrefix)     { $QueryParams.DomainPrefix = $DomainPrefix }
    if ($PSBoundParameters.ContainsKey('CustomerTenantType')) { $QueryParams.CustomerTenantType = $CustomerTenantType }
    if ($InvoiceProfileId) { $QueryParams.InvoiceProfileId = $InvoiceProfileId }
    if ($Search)           { $QueryParams.Search = $Search }

    (Invoke-Api -Path "/CustomerTenants" -Query $QueryParams).Items
}
