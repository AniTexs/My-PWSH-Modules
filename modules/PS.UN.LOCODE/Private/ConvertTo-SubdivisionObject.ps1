function ConvertTo-SubdivisionObject {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [psobject]
        $InputObject
    )
    [PSCustomObject]@{
        Geo                = @{
            Latitude  = $null
            Longitude = $null
        }
        Name               = $InputObject.'rdfs:label' | ForEach-Object {
            @{
                Language = $_.'@language' ?? ''
                Name     = $_.'@value'
            }
        }
        Code               = $InputObject.'rdf:value'.Substring(2)
        CountryCode        = $InputObject.'rdf:value'.substring(0, 2)
        CountrySubdivision = $InputObject.'unlcdv:countrySubdivision' | ForEach-Object { ($_.'@id' -split ':')[1] }
        Functions          = $InputObject.'unlcdv:functions'.'@id' | Get-UNCEFunction
    }
}