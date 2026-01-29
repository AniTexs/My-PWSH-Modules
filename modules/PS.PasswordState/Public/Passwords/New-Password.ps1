function New-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0,ValueFromPipelineByPropertyName=$true)]
        $Title,
        [Parameter(Mandatory, Position=1,ValueFromPipelineByPropertyName=$true)]
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

    # Make sure it does not already exist?
    $existing = Find-Password -SearchTerm $Title | Where-Object {$_.Title -eq $Title}
    if ($existing) {
        throw "A password with the title '$Title' already exists with ID $($existing.PasswordId). Use Set-Password to update existing passwords."
    }

    $Path = "/passwords"
    $ctx = $script:PWST_Context
    $Body = @{}
    $Bound = $PSBoundParameters.Keys | Where-Object { $_ -ne 'Verbose' }
    foreach ($key in $Bound) {
        if ($key -eq 'Password') {
            $Body[$key] = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        } else {
            $Body[$key] = $PSBoundParameters[$key]
        }
    }
    $Body["PasswordListID"] = $ctx.PasswordListId # Standard Password
    $Body["AllowExport"] = -not $DenyExport.IsPresent ? $true : $false
    try {
        $resp = Invoke-PWSTRequest -Method Post -Path $Path -Body $Body -ErrorAction Stop
        return $resp
    }
    catch {
        throw "Failed to create new password: $($_.Exception.Message)"
    }
}
