function Get-Password {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position=0,ValueFromPipelineByPropertyName=$true)]
        [int]$PasswordId,
        [Switch]$AllParameters,
        [ValidateSet("Domain","HostName","Description","AccountTypeID","Notes","URL","ExpiryDate","AllowExport","AccountType","OTP","OTPUri","WebUser_ID","WebPassword_ID","WebOTP_ID","WebGenericField1_ID","WebGenericField2_ID","WebGenericField3_ID","WebGenericField4_ID","WebGenericField5_ID","WebGenericField6_ID","WebGenericField7_ID","WebGenericField8_ID","WebGenericField9_ID","WebGenericField10_ID","GenericField1","GenericField2","GenericField3","GenericField4","GenericField5","GenericField6","GenericField7","GenericField8","GenericField9","GenericField10")]
        [String[]]$AdditionalProperties
    )
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }
    $SelectingProperties = @("PasswordId","Title","Username","Password")
    if ($AdditionalProperties) {
        $AdditionalProperties | % {
            if (-not ($SelectingProperties -contains $_)) {
                $SelectingProperties += $_
            }
        }
    }


    $Path = "/passwords/$PasswordId"
    $resp = Invoke-PWSTRequest -Method Get -Path $Path
    if ($AllParameters.IsPresent) { return $resp }
    $returnObj = [PSCustomObject]@{}
    # Add default properties
    foreach ($prop in $SelectingProperties) {
        if ($prop -is [string]) {
            $returnObj | Add-Member -MemberType NoteProperty -Name $prop -Value $resp.$prop
        } elseif ($prop -is [hashtable]) {
            $returnObj | Add-Member -MemberType NoteProperty -Name $prop.l -Value (& $prop.e)
        }
    }
    # Check if it has GenericFieldInfo
    if($resp.PSObject.Properties.Name -contains 'GenericFieldInfo' -and $resp.GenericFieldInfo){
        # Now add each GenericField to the $SelectingProperties
        foreach ($field in $resp.GenericFieldInfo) {
            $fieldName = $field.DisplayName -replace '\s',''
            if(-not ($returnObj.PSObject.Properties.Name -contains $fieldName)) {
                $returnObj | Add-Member -MemberType NoteProperty -Name $fieldName -Value $field.Value
            }
            if (-not ($SelectingProperties -contains $fieldName)) {
                $SelectingProperties += @{l=$fieldName; e={ $field.Value }}
            }
        }
    }

    return $returnObj
}