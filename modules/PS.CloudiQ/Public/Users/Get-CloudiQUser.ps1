function Get-CloudiQUser {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Search,
        [int]
        $OrganizationId,
        [int]
        # Translation needed before using this parameter
        #[ValidateSet(0, 1, 2, 8, 16, 32)]
        #$Role,
        [int]
        $Page = 1,
        [int]
        $PageSize = 15
    )

    $QueryParams = @{
        Page = $Page
        PageSize = $PageSize
    }
    if($Search){
        $QueryParams.Search = $Search
    }
    if($OrganizationId){
        $QueryParams.OrganizationId = $OrganizationId
    }

    (Invoke-Api -Path "/users" -Query $QueryParams).Items

}