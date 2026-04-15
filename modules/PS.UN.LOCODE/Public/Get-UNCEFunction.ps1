function Get-UNCEFunction {
    param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Function
    )
    begin {
        $data = (Invoke-UNCERequest -Path "unlocode-functions").'@graph' | Select-Object @{l = 'Country'; e = { $_.'rdfs:label' } }, @{l = 'Code'; e = { $_.'rdf:value' } }
    }
    process {
        if ($Function) {
            $str = $Function -replace "unlcdf:", ""
            $data | Where-Object { $_.Code -eq $str } | Select-Object @{l="Function";e={$_.Country}},Code
        }
        else {
            $data | Select-Object @{l="Function";e={$_.Country}},Code
        }
    }
}