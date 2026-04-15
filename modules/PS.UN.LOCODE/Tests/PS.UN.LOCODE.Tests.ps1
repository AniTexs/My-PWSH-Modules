$here = Split-Path -Parent $PSCommandPath
$moduleRoot = Join-Path $here '..'
Import-Module (Join-Path $moduleRoot 'PS.UN.LOCODE.psd1') -Force

InModuleScope -ModuleName "PS.UN.LOCODE" {
    BeforeAll {
        Import-Module "PS.UN.LOCODE" -Force
    }

    Describe "Get-UNCECountrySubdivision" {
        It "Get Subdivisions in Country" {
            $subdivisions = Get-UNCECountrySubdivision -CountryCode DK
            $subdivisions.Count | Should -BeGreaterThan 0
            $subdivisions.GetType().Name | Should -Be "Object[]"
            $subdivisions[0].GetType().Name | Should -Be "PSCustomObject"
        }
        It "Get Subdivisions in Country in Hashtable format" {
            $subdivisions = Get-UNCECountrySubdivision -CountryCode DK -Hashtable
            $subdivisions.Count | Should -BeGreaterThan 0
            $subdivisions.GetType().Name | Should -BeIn @("OrderedDictionary", "Hashtable")
        }

    }

    Describe "Get-UNCEFunction" {
        It "Returns all functions" {
            $functions = Get-UNCEFunction
            $functions.Count | Should -BeGreaterThan 0
            $functions.GetType().Name | Should -Be "Object[]"
            $functions[0].GetType().Name | Should -Be "PSCustomObject"
        }
        It "Returns specific function" {
            $function = Get-UNCEFunction -Function '1'
            $function.Count | Should -Be 1
            $function.GetType().Name | Should -Be "PSCustomObject"
        }
    }

    Describe "Get-UNCECountry" {
        It "Can retrieve country information" {
            (Get-UNCECountry).Count | Should -BeGreaterThan 0
        }
        It "Can Search for countries" {
            (Get-UNCECountry -Search "Denmark").Count | Should -BeGreaterThan 0
        }
        It "Can return hashtable format" {
            (Get-UNCECountry -Search "Denmark" -Hashtable | Select-Object -first 1).GetType().Name | Should -BeIn @("OrderedDictionary", "Hashtable")
        }
        It "Include subdivisions with output" {
            (Get-UNCECountry -Search "Denmark" -WithSubdivisions).PSObject.Properties.Name | Should -Contain "Subdivisions"
        }
        It "Fails on function without subdivisions" {
            { Get-UNCECountry -Search "Denmark" -WithFunctions } | Should -Throw
        }
        It "Return function with subdivisions" {
            (Get-UNCECountry -Search "Denmark" -WithSubdivisions -WithFunctions).PSObject.Properties.Name | Should -Contain "Subdivisions"

        }
    }

}