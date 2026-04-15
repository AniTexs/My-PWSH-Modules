function Get-UNCECountrySubdivision {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('\w{2}')]
        [string]
        $CountryCode,

        [Parameter()]
        [ValidateScript({ $_ -in (Get-UNCEFunction).Code }, ErrorMessage = "Invalid function code. Use Get-UNCEFunction to see valid codes.")]
        [char[]]
        $FunctionCode,

        [Parameter()]
        [switch]
        $Hashtable
    )
    
    $Data = (Get-UNCEData).'@graph'
    $Data = $data | Where-Object { $_.'unlcdv:countryCode'.'@id' -eq "unlcdc:$CountryCode" } | ForEach-Object { $_ | ConvertTo-SubdivisionObject }
    if ($FunctionCode) {
        # Find Locations only with the specified functions available.
        $Data = $Data | Where-Object { 
            foreach ($code in $_.Functions.Code) {
                if ($code -in $FunctionCode) { 
                    return $true
                }
            } 
        }
    }
    if ($Hashtable) {
        $result = [ordered]@{}

        foreach ($subdivision in $data) {
            $result[$subdivision.Code] = $subdivision
        }

        return $result
    }
    $Data
}