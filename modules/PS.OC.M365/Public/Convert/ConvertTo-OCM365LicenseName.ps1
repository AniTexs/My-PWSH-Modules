function ConvertTo-OCM365LicenseName {
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
    process {
        # Get the Friendly Name of the License
        $SkuPartNumber | Get-OCM365MicrosoftLicenses | select -ExpandProperty DisplayName
    }
}