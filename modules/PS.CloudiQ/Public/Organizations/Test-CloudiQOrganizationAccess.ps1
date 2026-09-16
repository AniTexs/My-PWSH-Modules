function Test-CloudiQOrganizationAccess {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [int]
        $Id
    )
    Invoke-Api -Path "/organizations/HasAccess/$Id"
}
