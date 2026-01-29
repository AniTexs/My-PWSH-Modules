function Set-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0,ValueFromPipelineByPropertyName=$true)]
        [int]$PasswordID,
        [string]$Title,
        [securestring]$Password,
        [string]$Username,
        [string]$Domain,
        [string]$HostName,
        [string]$Description,
        [string]$GenericField1,
        [string]$GenericField2,
        [string]$GenericField3,
        [string]$GenericField4,
        [string]$GenericField5,
        [string]$GenericField6,
        [string]$GenericField7,
        [string]$GenericField8,
        [string]$GenericField9,
        [string]$GenericField10,
        [hashtable]$GenericFieldInfo,
        [string]$Notes,
        [string]$URL,
        [switch]$DenyExport
    )

    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    if(-not (Get-Password -PasswordID $PasswordID)){
        throw "No password found with ID $PasswordID"
    }
    $Body = @{
        PasswordID = $PasswordID
        AllowExport = -not $DenyExport.IsPresent ? $true : $false
    }
    $Bound = $PSBoundParameters.Keys | Where-Object { $_ -ne 'Verbose' -and $_ -ne 'PasswordID' }
    foreach ($key in $Bound) {
        if ($key -eq 'Password') {
            $Body[$key] = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        } else {
            $Body[$key] = $PSBoundParameters[$key]
        }
    }

    $Path = "/passwords"
    $resp = Invoke-PWSTRequest -Method Put -Path $Path -Body $Body
    return $resp
}