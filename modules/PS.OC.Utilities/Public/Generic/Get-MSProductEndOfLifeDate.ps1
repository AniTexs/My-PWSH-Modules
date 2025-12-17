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
        [Parameter(Mandatory = $true,ParameterSetName = "Default")]
        [Parameter(Mandatory = $true,ParameterSetName = "Specific")]
        [string]
        $Product,
        [Parameter(Mandatory = $true,ParameterSetName = "Specific")]
        [string]
        $Cycle,
        [Parameter(Mandatory = $true,ParameterSetName = "ADComputer",ValueFromPipeline = $true)]
        [Microsoft.ActiveDirectory.Management.ADComputer]
        $Computer
    )
    switch ($PSCmdlet.ParameterSetName){
        'ADComputer' {
            $Computer = $Computer | Get-ADComputer -Properties OperatingSystem
            if($Computer.OperatingSystem -notlike "*Server*"){
                Write-Warning "Computer $($Computer.SamAccountName) is not a server"
                return
            }
            $OS = $Computer.OperatingSystem
            $Product = ($OS -split [regex]"\d")[0].Trim() -replace " ", "-"
            $Cycle = ($OS.Substring($product.Length + 1) -replace "Standard", "").Trim() -replace " ", "-"
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
    } catch {
        <#Do this if a terminating exception happens#>
    }

}