function Get-M365FriendlyLicenseName {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            Mandatory = $true,
            ParameterSetName = 'SkuPartNumberArray'
        )]
        [string]
        $SkuPartNumber
    )
    begin {
        $Licenses = Get-AllMicrosoftLicenses
    }
    process {
        # Get the Friendly Name of the License
        $Licenses | Where-Object String_ID -eq $SkuPartNumber | Select-Object -ExpandProperty Product_Display_Name -First 1
    }
}