function Get-OCM365MicrosoftLicenses {
    <#
    .SYNOPSIS
        Retrieves all Microsoft 365 licenses and their friendly name.

    .DESCRIPTION
        Gets all licenses from Microsoft, All SKU's and service plans included.
        Pulls a CSV from Microsoft and imports and groups the licenses by their GUID (SkuId).
        Url: https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference

    .PARAMETER DisplayName
        Search for a license by its display name.
        It's regex based searching.

    .PARAMETER SkuPartNumber
        Get a license only by the SkuPartNumber.

    .PARAMETER SkuId
        Get a license only by the SkuId

    .PARAMETER Type
        Specifies the type of license to filter by. Valid values are 'Commerical', 'Goverment', 'Education', and 'Nonprofit'.

    .PARAMETER NoWarningMessage
        If specified, suppresses warning messages about the reliability of the Type property.

    .EXAMPLE
        Get-OCM365MicrosoftLicenses -DisplayName "Microsoft 365 Business Premium"
        Retrives all licenses that contain "Microsoft 365 Business Premium" in their display name.

    .EXAMPLE
        Get-OCM365MicrosoftLicenses -DisplayName "Microsoft 365 Business Premium"
        Retrives all licenses that contain "Microsoft 365 Business Premium" in their display name.

    .NOTES
        Requires Microsoft Graph PowerShell module and an active Graph connection.
        Required Graph API permissions: Organization.Read.All, User.Read.All
    #>
    [CmdletBinding()]
    param (
        $DisplayName,
        [Parameter(ValueFromPipelineByPropertyName)]
        $SkuPartNumber,
        [Parameter(ValueFromPipelineByPropertyName)]
        $SkuId,
        [ValidateSet('Commerical', 'Goverment', 'Education', 'Nonprofit')]
        [String]
        $Type,
        [switch]
        $NoWarningMessage
    )
    begin {

        $Filters = @{
            LicenseType = @{
                Goverment = '(USGOV|_GOV|_G\d_|_G\d$)'
                Education = '(_EDU|_A\d_|_A\d$|ALUMNI|Microsoft 365 A\d|STUDENT)'
                Nonprofit = '(NONPROFIT|Non_Profit|Nonprofit)'
            }
        }


        # Check if the cached $Script:M365Licenses exist
        if (-not (Get-Variable -Name M365Licenses -Scope Script -ErrorAction SilentlyContinue)) {
        
            if (-not ($NoWarningMessage.IsPresent)) {
                Write-Warning "The Type property can be unreliable, don't rely on it for truthfulness."
            }

            $RequestParams = @{
                Uri = "https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv"
            }
            $Script:M365Licenses = Invoke-RestMethod @RequestParams `
            | ConvertFrom-Csv -Delimiter ',' `
            | Group-Object GUID | ForEach-Object {
                $LicenseType = "Commerical"
                if ($_.Group[0].String_Id -cmatch $Filters.LicenseType.Goverment) { $LicenseType = "Government" }
                if ($_.Group[0].String_Id -cmatch $Filters.LicenseType.Education) { $LicenseType = "Education" }
                if ($_.Group[0].String_Id -cmatch $Filters.LicenseType.Nonprofit) { $LicenseType = "Nonprofit" }
                <#
            TODO:
            Some String_Id's include spaces?
            Should spaces be removed? No clue currently
            Ex:
            DisplayName   : Microsoft 365 Business Premium (no Teams)
            SkuId         : 00e1ec7b-e4a3-40d1-9441-b69b597ab222
            SkuPartNumber : Microsoft_365_ Business_ Premium_(no Teams)
            #>
                [PSCustomObject]@{
                    DisplayName   = $_.Group[0].Product_Display_Name
                    SkuId         = $_.Name
                    Type          = $LicenseType
                    SkuPartNumber = $_.Group[0].String_Id
                    ServicePlans  = $_.Group | ForEach-Object {
                        [PSCustomObject]@{
                            DisplayName   = $_.Service_Plans_Included_Friendly_Names
                            SkuId         = $_.Service_Plan_Id
                            SkuPartNumber = $_.Service_Plan_Name
                        }
                    }
                }
            }
        }

    }
    process {
        if ($SkuId -or $SkuPartNumber) {
            if ($SkuId) {
                return ($Script:M365Licenses | Where-Object { $_.SkuId -eq $SkuId })
            }
            if ($SkuPartNumber) {
                return ($Script:M365Licenses | Where-Object { $_.SkuPartNumber -eq $SkuPartNumber })
            }
        }


        $return = $Script:M365Licenses
        # Apply Filtering on DisplayName, Type
        if ($DisplayName) {
            $return = $return | Where-Object { $_.DisplayName -match $DisplayName }
        }
        if ($Type) {
            $FilterPattern = $Filters.LicenseType.$Type
            $return = $return | Where-Object { $_.SkuPartNumber -match $FilterPattern }
        }
        return $return
    }
    
}