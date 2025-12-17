
function Add-ElasticBulkFromObjects {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$Index,
        [Parameter(ValueFromPipeline, Mandatory)]$InputObject,
        [string]$IdProperty,
        [ValidateSet('true', 'wait_for')][string]$Refresh,
        [int]$BatchSize = 1000
    )
    begin { $buffer = New-Object System.Collections.Generic.List[object] }
    process {
        $buffer.Add($InputObject)
        if ($buffer.Count -ge $BatchSize) {
            $ops = @()
            foreach ($obj in $buffer) {
                $meta = @{ index = @{ } }
                if ($IdProperty -and $obj.PSObject.Properties[$IdProperty]) {
                    $meta.index._id = [string]$obj.$IdProperty
                }
                $meta.index._index = $Index
                $ops += $meta
                $ops += $obj
            }
            Invoke-ElasticBulk -Operations $ops -Refresh $Refresh | Out-Null
            $buffer.Clear()
        }
    }
    end {
        if ($buffer.Count -gt 0) {
            $ops = @()
            foreach ($obj in $buffer) {
                $meta = @{ index = @{ } }
                if ($IdProperty -and $obj.PSObject.Properties[$IdProperty]) {
                    $meta.index._id = [string]$obj.$IdProperty
                }
                $meta.index._index = $Index
                $ops += $meta
                $ops += $obj
            }
            Invoke-ElasticBulk -Operations $ops -Refresh $Refresh
        }
    }
}