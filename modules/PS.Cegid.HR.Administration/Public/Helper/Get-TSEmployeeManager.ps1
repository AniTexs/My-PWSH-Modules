function Get-TSEmployeeManager {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("EmployeeId", "Id")]
        [int]
        $EmployeeNumber
    )
    
    
    begin {
        Write-Verbose "[Get-TSEmployeeManager] Starting employee retrieval process"
    }
    
    process {
        Write-Debug "[Get-TSEmployeeManager] Retrieving employee: $EmployeeNumber"
        $Employee = Get-TSEmployee -EmployeeNumber $EmployeeNumber
        Write-Debug "[Get-TSEmployeeManager] Employee data: $($Employee | ConvertTo-Json -Depth 2 -Compress)"
        Write-Debug "[Get-TSEmployeeManager] Getting manager for employee $EmployeeNumber"
        $EmployeeManagerId = $Employee | Get-TSEmployeeOrganizations | Select-Object -ExpandProperty managerEmployeeNumber -First 1
        Write-Debug "[Get-TSEmployeeManager] Manager Employee Number: $EmployeeManagerId"
        
        if (-not $EmployeeManagerId) {
            Write-Verbose "[Get-TSEmployeeManager] Employee $EmployeeNumber has no manager assigned."
            return $null
        }

        # Get the Employee Manager details
        Get-TSEmployee -EmployeeId $EmployeeManagerId
    }
    
    end {
        Write-Verbose "[Get-TSEmployeeManager] Completed employee manager retrieval"
    }
}