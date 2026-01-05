function Get-MSProductEndOfLifeDate {
    <#
    .SYNOPSIS
    Get Information regarding the end of life date for a product

    .DESCRIPTION
    Long description

    .PARAMETER Product
    Parameter description

    .PARAMETER Cycle
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>
    [CmdletBinding(DefaultParameterSetName = "Default")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "ADComputer", ValueFromPipeline = $true)]
        [Microsoft.ActiveDirectory.Management.ADComputer]
        $Computer
    )
    DynamicParam {
        $RunTime = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        
        # Dynamic Product Parameter
        $ProductParamName = "Product"
        $ProductParamSet = "Specific"
        $ProductAttrCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
        $ProductParamAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $ProductParamAttribute.Mandatory = $true
        $ProductParamAttribute.ParameterSetName = $ProductParamSet
        $ProductArrSet = (Invoke-RestMethod -Uri "https://endoflife.date/api/v1/products" -Method Get).result.name
        $ProductValidateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new([string[]]$ProductArrSet)
        $ProductAttrCollection.Add($ProductParamAttribute)
        $ProductAttrCollection.Add($ProductValidateSetAttribute)
        $RunTime.Add($ProductParamName, [System.Management.Automation.RuntimeDefinedParameter]::new($ProductParamName, [string], $ProductAttrCollection))
        
        # Dynamic Cycle Parameter
        $CycleParamName = "Cycle"
        $CycleParamSet = "Specific"
        $CycleAttrCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
        $CycleParamAttribute = [System.Management.Automation.ParameterAttribute]::new()
        $CycleParamAttribute.Mandatory = $true
        $CycleParamAttribute.ParameterSetName = $CycleParamSet
        $CycleAttrCollection.Add($CycleParamAttribute)
        
        # Get cycles based on selected product
        if ($PSBoundParameters.ContainsKey("Product")) {
            try {
                $Product = $PSBoundParameters["Product"]
                $CycleArrSet = (Invoke-RestMethod -Uri "https://endoflife.date/api/v1/products/$Product" -Method Get).result.releases.name
                $CycleValidateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new([string[]]$CycleArrSet)
                $CycleAttrCollection.Add($CycleValidateSetAttribute)
            }
            catch {
                # If API fails, don't add ValidateSet
            }
        }
        
        $RunTime.Add($CycleParamName, [System.Management.Automation.RuntimeDefinedParameter]::new($CycleParamName, [string], $CycleAttrCollection))
        
        return $RunTime
    }
    begin {
        $Product = $PSBoundParameters["Product"]
        $Cycle = $PSBoundParameters["Cycle"]
        
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ADComputer' {
                $Computer = $Computer | Get-ADComputer -Properties OperatingSystem
                if ($Computer.OperatingSystem -notlike "*Server*") {
                    Write-Warning "Computer $($Computer.SamAccountName) is not a server"
                    return
                }
                $OS = $Computer.OperatingSystem
                $Product = ($OS -split [regex]"\d")[0].Trim() -replace " ", "-"
                $Cycle = ($OS.Substring($product.Length + 1) -replace "Standard", "").Trim() -replace " ", "-"
                $url = "$Product/$Cycle"
            }
            'Specific' {
                $url = "$Product/$Cycle"
            }
        }

        try {
            Invoke-Webrequest -Uri "https://endoflife.date/api/$url.json" -UseBasicParsing -ErrorAction Stop | Select-Object -ExpandProperty content | convertfrom-json
        }
        catch [System.Net.WebException] {
            Write-Warning "Unable to get end of life date"
            Write-Warning "Product: $Product"
            Write-Warning "Cycle: $Cycle"
            #write
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
    }

}