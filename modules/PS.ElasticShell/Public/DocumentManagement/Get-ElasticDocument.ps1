function Get-ElasticDocument { 
    [CmdletBinding()]
    param(
        [string]$Index, 
        [Parameter(Mandatory)]
        [string]$Id) 
    $idx = Ensure-Index -Index $Index; Invoke-ElasticRequest -Method GET -Path "/$idx/_doc/$Id" 
}
