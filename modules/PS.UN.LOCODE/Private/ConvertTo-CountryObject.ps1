function ConvertTo-CountryObject {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [psobject]
        $InputObject
    )
    process {
        [PSCustomObject]@{
            Country = $InputObject.'rdfs:label'
            Code = $InputObject.'rdf:value'
        }
    }
}