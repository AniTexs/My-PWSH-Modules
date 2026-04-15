function ConvertFrom-UNCEObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [psobject[]]
        $InputObject
    )
    begin {

    }
    process {
        if($InputObject.'@type'){
            switch ($InputObject.'@type') {
                'unlcdv:Country' { $InputObject | ConvertTo-CountryObject }
                'unlcdv:Function' {  }
                'unlcdv:Subdivision' {  }
                'unlcdv:UNLOCODE' {  }
                'unlcdv:countrySubdivision' { $InputObject | ConvertTo-SubdivisionObject }
                #Default {}
            }
        }else {
            Write-Debug "InputObject does not have a '@type' property."
            $InputObject
        }
    }
}