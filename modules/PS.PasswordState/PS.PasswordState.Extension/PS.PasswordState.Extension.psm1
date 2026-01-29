
#region Helpers
function ConnectToPWST {
    param($AdditionalParameters)
    return (PS.PasswordState\Connect-PasswordState @AdditionalParameters -Verbose)
}
function New-PSSecretInfo {
    param([string]$Name, [string]$VaultName, [string]$Type)
    $stype = switch ($Type) {
        'String' { [Microsoft.PowerShell.SecretManagement.SecretType]::String }
        'Hashtable' { [Microsoft.PowerShell.SecretManagement.SecretType]::Hashtable }
        'SecureString' { [Microsoft.PowerShell.SecretManagement.SecretType]::SecureString }
        'PSCredential' { [Microsoft.PowerShell.SecretManagement.SecretType]::PSCredential }
        'ByteArray' { [Microsoft.PowerShell.SecretManagement.SecretType]::ByteArray }
        default { [Microsoft.PowerShell.SecretManagement.SecretType]::Unknown }
    }
    [Microsoft.PowerShell.SecretManagement.SecretInformation]::new($Name, $stype, $VaultName, $null)
}
function GetPasswordStateType {
    param($Response)
    if (($Response | Select-Object -ExcludeProperty PasswordID, Title | Get-Member -MemberType NoteProperty | Measure-Object).Count -gt 2) {
        return 'Hashtable'
    }
    if ((-not [String]::IsNullOrWhiteSpace($Response.UserName)) -and (-not [String]::IsNullOrWhiteSpace($Response.Password))) {
        return 'PSCredential'
    }
    return 'SecureString'
}
function FormatPasswordStateCredential {
    param($Response)
    $StateType = GetPasswordStateType -Response $Response
    Write-Debug "Formatting Passwordstate response as type '$StateType'"
    switch ($StateType) {
        'PSCredential' {
            $pw = $Response.Password
            if ($pw -is [string]) { $pw = ConvertTo-SecureString -String $pw -AsPlainText -Force }
            return New-Object System.Management.Automation.PSCredential($Response.Username, $pw)
        }
        'SecureString' {
            $pw = $Response.Password
            if ($pw -is [string]) { $pw = ConvertTo-SecureString -String $pw -AsPlainText -Force }
            return $pw
        }
        'Hashtable' {
            $ht = @{}
            $props = $Response | Select-Object -ExcludeProperty PasswordID, Title | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            foreach ($p in $props) {
                $ht[$p] = $Response.$p
            }
            return $ht
        }
        'ByteArray' {
            $pw = $Response.Password
            if ($pw -is [string]) { $pw = [System.Text.Encoding]::ASCII.GetBytes($pw) }
            return $pw
        }
        Default {
            return $Response.Password
        }
    }
}
#endregion

#region Finished and confirmed working.
function Get-Secret {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$VaultName,
        [hashtable]$AdditionalParameters
    )
    Write-Verbose "Get-Secret:: Getting secret '$Name' from vault '$VaultName'..."
    $Connected = (PS.PasswordState\Connect-PasswordState @AdditionalParameters -Verbose)
    if (-not $Connected) { throw "Could not connect to Passwordstate vault '$VaultName'." }
    $Passwords = PS.PasswordState\Find-PasswordStatePassword -SearchTerm $Name
    # If multiple results, take the one with exact title match
    if ($Passwords.Count -gt 1) { throw "Multiple passwords found with name '$Name' in vault '$VaultName'." }
    if ($Passwords.Count -eq 0) { throw "No password found with name '$Name' in vault '$VaultName'." }
    $Password = $Passwords | Select-Object -First 1
    Write-Verbose "Found password with ID $($Password.PasswordID) and title '$($Password.Title)'. Retrieving full details..."
    #$Password = $Password | Select-Object -ExpandProperty PasswordID
    $Password = (PS.PasswordState\Get-PasswordStatePassword -PasswordID $Password.PasswordId)
    Write-Verbose "Retrieved password details. Processing return value..."
    return (FormatPasswordStateCredential -Response $Password)
}

function Get-SecretInfo {
    [CmdletBinding()]
    param(
        [string]$Filter,
        [Parameter(Mandatory)][string]$VaultName,
        [hashtable]$AdditionalParameters
    )
    begin {
        Write-Verbose "Get-SecretInfo:: Getting secrets with filter '$Filter' from vault '$VaultName'..."
        $Connected = (PS.PasswordState\Connect-PasswordState @AdditionalParameters -Verbose)
        if (-not $Connected) { throw "Could not connect to Passwordstate vault '$VaultName'." }
    }
    process {
        $Passwords = PS.PasswordState\Find-PasswordStatePassword -SearchTerm $Filter
        $Infos = foreach ($i in $Passwords) {
            $pw = PS.PasswordState\Get-PasswordStatePassword -PasswordID $i.PasswordId
            # If username exists, it's a PSCredential; else SecureString
            #if($null -ne $pw.Username -and $pw.Username -ne '') { $type = 'PSCredential' } else { $type = 'SecureString' }
            
            $type = (GetPasswordStateType -Response $pw)
            Write-Debug "Found secret
            $($pw.Title) with type $type"

            New-PSSecretInfo -Name $pw.Title -VaultName $VaultName -Type $type
        }
        return $Infos
    }
}

function Test-SecretVault {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$VaultName,
        [hashtable]$AdditionalParameters
    )
    Write-Verbose "Testing connection to vault '$VaultName'..."
    $Connected = $false
    try {
        Write-Debug "Connecting with parameters: $($AdditionalParameters | Out-String)"
        $Connected = (PS.PasswordState\Connect-PasswordState @AdditionalParameters -Verbose)
        Write-Verbose "Connection test: $Connected"
    }
    catch {
        Write-Error $_
    }
    return $Connected
    if ($true) {
        $ctx = PS.PasswordState\Get-PasswordStateContext
        if ($null -ne $ctx) { return $true }
    }
    return $false
}

function Unlock-SecretVault {
    [CmdletBinding()]
    param([SecureString]$Password, [string]$VaultName, [hashtable]$AdditionalParameters)
    # Not required for Passwordstate’s API (API key already unlocks).
    return
}
#endregion


# WIP
function Set-Secret {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][object]$Secret,
        [Parameter(Mandatory)][string]$VaultName,
        [hashtable]$AdditionalParameters
    )
    $BodyParams = @{
        Title = $Name
    }
    switch ($Secret.GetType().Name) {
        'Byte[]' {
            $SecretString = [System.Text.Encoding]::ASCII.GetString($Secret)
            $BodyParams.Password = $SecretString
            #Set-String -Name $Name -Secret $SecretString -AZKVaultName $AZKVaultName -ContentType $ContentType
            #Set-ByteArray -Name $Name -Secret $Secret -AZKVaultName $AdditionalParameters.AZKVaultName -ContentType 'ByteArray'
        }
        'String' {
            $BodyParams.Password = $Secret | ConvertTo-SecureString -AsPlainText -Force
            #Set-String -Name $Name -Secret $Secret -AZKVaultName $AdditionalParameters.AZKVaultName -ContentType 'String'
        }
        'SecureString' {
            #$SecretString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secret))
            $BodyParams.Password = $Secret  
            #Set-SecureString -Name $Name -Secret $Secret -AZKVaultName $AdditionalParameters.AZKVaultName -ContentType 'SecureString'
        }
        'PSCredential' {
            $pw = $Secret.GetNetworkCredential().Password
            $BodyParams.Password = $pw | ConvertTo-SecureString -AsPlainText -Force
            $BodyParams.UserName = $Secret.UserName
            #Set-PSCredential -Name $Name -Secret $Secret -AZKVaultName $AdditionalParameters.AZKVaultName -ContentType 'PSCredential'
        }
        'Hashtable' {
            throw "Storing hashtables is not supported in Passwordstate."
            #Set-Hashtable -Name $Name -Secret $Secret -AZKVaultName $AdditionalParameters.AZKVaultName -ContentType 'Hashtable'
        }
        Default {
            #throw "Invalid type. Types supported: byte[], string, SecureString, PSCredential, Hashtable";
            throw "Invalid type. Types supported: byte[], string, SecureString and PSCredential";
        }
    }

    Write-Verbose "Set-Secret:: Setting secret '$Name' in vault '$VaultName'..."
    $Connected = (PS.PasswordState\Connect-PasswordState @AdditionalParameters -Verbose)
    if (-not $Connected) { throw "Could not connect to Passwordstate vault '$VaultName'." }
    $Existing = PS.PasswordState\Find-PasswordStatePassword -SearchTerm $Name
    if ($Existing.Count -gt 1) { throw "Multiple passwords found with name '$Name' in vault '$VaultName'." }
    if ($Existing.Count -eq 0) { 
        Write-Verbose "No existing password found with name '$Name'. Creating new entry..."
        #$BodyParams.PasswordListID = $AdditionalParameters.PasswordListID
        #if(-not $BodyParams.PasswordListID) { throw "To create a new password, you must provide a PasswordListID in AdditionalParameters." }
        try {
            $New = PS.PasswordState\New-PasswordStatePassword @BodyParams -ErrorAction Stop
            $PulledFresh = PS.PasswordState\Get-PasswordStatePassword -PasswordID $New.PasswordID
            Write-Verbose "Created new password with ID $($New.PasswordID) and title '$($New.Title)'."
            return (FormatPasswordStateCredential -Response $PulledFresh)
        }
        catch {
            throw "Failed to create new password: $($_.Exception.Message)"
        }
    }
    else {
        if ($Existing.Count -eq 1) {
            $Existing = $Existing | Select-Object -First 1
            Write-Verbose "Found existing password with ID $($Existing.PasswordID). Updating entry..."
            $Updated = PS.PasswordState\Set-PasswordStatePassword -PasswordID $Existing.PasswordID @BodyParams
            $PulledFresh = PS.PasswordState\Get-PasswordStatePassword -PasswordID $Updated.PasswordID

            Write-Verbose "Updated password with ID $($Updated.PasswordID) and title '$($Updated.Title)'."
            return (FormatPasswordStateCredential -Response $PulledFresh)
        }
    }
}

function Remove-Secret {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$VaultName,
        [hashtable]$AdditionalParameters
    )
}

# Not started...





function Set-SecretInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Name,
        [hashtable]$Metadata,
        [Parameter(Mandatory)][string]$VaultName,
        [hashtable]$AdditionalParameters
    )
    Write-Verbose "Set-Secret:: Setting secret '$Name' in vault '$VaultName'..."
    $Connected = (PS.PasswordState\Connect-PasswordState @AdditionalParameters -Verbose)
    if (-not $Connected) { throw "Could not connect to Passwordstate vault '$VaultName'." }
    $Existing = PS.PasswordState\Find-PasswordStatePassword -SearchTerm $Name
    if ($Existing.Count -gt 1) { throw "Multiple passwords found with name '$Name' in vault '$VaultName'." }
    if ($Existing.Count -eq 0) { throw "No password found with name '$Name' in vault '$VaultName'." }
    $Password = $Existing | Select-Object -First 1
    $Password = (PS.PasswordState\Get-PasswordStatePassword -PasswordID $Password.PasswordId)
    # UNable to set Username and Password only. Other fields can be set.
    return PS.PasswordState\Set-PasswordStatePassword -PasswordID $Password.PasswordID @Metadata

}