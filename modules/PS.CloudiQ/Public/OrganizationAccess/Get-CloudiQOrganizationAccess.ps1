function Get-CloudiQOrganizationAccess {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        # Defaults to the currently connected user when omitted
        $UserId = $Script:oAuthObject.User_Id,
        [Parameter()]
        [int]
        $OrganizationId
    )
    $QueryParams = @{
        userId = $UserId
    }
    if($OrganizationId){
        $QueryParams.organizationId = $OrganizationId
    }
    (Invoke-Api -Path "/OrganizationAccess" -Query $QueryParams).Items
}
