function Test-Authentication {
    <#
    .SYNOPSIS
    Test if a user's credentials are valid (Domain or Local machine)

    .DESCRIPTION
    Returns $true / $false depending on whether the provided credentials are valid.
    Supports validating against:
      - Active Directory domain (Context = Domain)
      - Local SAM on this machine (Context = Local)
      - Auto-detect (default): .\user => Local, DOMAIN\user => Domain, user@upn => Domain, otherwise Domain first then Local.

    .PARAMETER Username
    Username to test. Supports: user, DOMAIN\user, .\user, COMPUTER\user, user@domain.tld

    .PARAMETER SecurePassword
    SecureString password.

    .PARAMETER UnencryptedPassword
    Plain-text password.

    .PARAMETER Credential
    PSCredential containing username and password.

    .PARAMETER Context
    Auto (default), Domain, or Local.

    .PARAMETER Domain
    Optional domain name to force when Context=Domain and Username is not DOMAIN\user / UPN.

    .EXAMPLE
    Test-ADAuthentication -Username "contoso\alice" -UnencryptedPassword "Password123"

    .EXAMPLE
    Test-ADAuthentication -Username ".\localuser" -UnencryptedPassword "Password123" -Context Local

    .EXAMPLE
    $cred = Get-Credential
    Test-ADAuthentication -Credential $cred
    #>
    [CmdletBinding(DefaultParameterSetName = 'Passed')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Passed', Position = 0, ValueFromPipeline = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Unencrypted', Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias("SamAccountName")]
        [string] $Username,

        [Parameter(Mandatory = $true, ParameterSetName = 'Passed', Position = 1)]
        [Alias("Password")]
        [System.Security.SecureString] $SecurePassword,

        [Parameter(Mandatory = $true, ParameterSetName = 'Unencrypted', Position = 1)]
        [string] $UnencryptedPassword,

        [Parameter(Mandatory = $true, ParameterSetName = 'Credential', Position = 0, ValueFromPipeline = $true)]
        [System.Management.Automation.PSCredential] $Credential,

        [ValidateSet('Auto', 'Domain', 'Local')]
        [string] $Context = 'Auto',

        [string] $Domain
    )

    begin {
        try {
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement -ErrorAction Stop | Out-Null
        } catch {
            throw "System.DirectoryServices.AccountManagement is not available. This function requires Windows / .NET support. Details: $($_.Exception.Message)"
        }
    }

    process {
        # Normalize inputs into $u (username), $p (plain password)
        switch ($PSCmdlet.ParameterSetName) {
            'Unencrypted' {
                $u = $Username
                $p = $UnencryptedPassword
            }
            'Passed' {
                $Credential = [pscredential]::new($Username, $SecurePassword)
                $u = $Credential.UserName
                $p = $Credential.GetNetworkCredential().Password
            }
            'Credential' {
                $u = $Credential.UserName
                $p = $Credential.GetNetworkCredential().Password
            }
        }

        # Parse username forms
        $parsed = [ordered]@{
            RawUser     = $u
            User        = $null
            Qualifier   = $null   # DOMAIN, COMPUTERNAME, '.', or $null
            IsUPN       = $false
            IsDotLocal  = $false
        }

        if ($u -match '^(?<qual>[^\\]+)\\(?<usr>.+)$') {
            $parsed.Qualifier = $Matches.qual
            $parsed.User      = $Matches.usr
            $parsed.IsDotLocal = ($parsed.Qualifier -eq '.')
        }
        elseif ($u -match '^(?<usr>[^@]+)@(?<upn>.+)$') {
            $parsed.User = $u  # keep UPN intact for ValidateCredentials
            $parsed.IsUPN = $true
        }
        else {
            $parsed.User = $u
        }

        $machineName = $env:COMPUTERNAME

        function Test-WithContext {
            param(
                [Parameter(Mandatory)] [ValidateSet('Domain','Local')] [string] $Which
            )
            try {
                $ct = if ($Which -eq 'Local') {
                    [System.DirectoryServices.AccountManagement.ContextType]::Machine
                } else {
                    [System.DirectoryServices.AccountManagement.ContextType]::Domain
                }

                # Decide what to pass to ValidateCredentials
                # - For Domain context:
                #   * If UPN, pass UPN directly
                #   * If DOMAIN\user, pass "user" and let domain be inferred from DC discovery (or override with -Domain)
                # - For Local context:
                #   * If ".\user" or "COMPUTER\user", pass "user"
                #   * Else pass raw user (it still works for many cases)
                $usernameToValidate = $parsed.User
                $contextName = $null

                if ($Which -eq 'Domain') {
                    if ($parsed.IsUPN) {
                        $usernameToValidate = $parsed.User
                    } elseif ($parsed.Qualifier -and $parsed.Qualifier -ne '.' -and $parsed.Qualifier -ne $machineName) {
                        # DOMAIN\user => validate as "user" in that domain
                        $usernameToValidate = $parsed.User
                        $contextName = $parsed.Qualifier
                    } elseif ($Domain) {
                        $contextName = $Domain
                    }
                }
                else {
                    if ($parsed.Qualifier -eq '.' -or $parsed.Qualifier -eq $machineName) {
                        $usernameToValidate = $parsed.User
                    }
                }

                $pc = if ($contextName) {
                    [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ct, $contextName)
                } else {
                    [System.DirectoryServices.AccountManagement.PrincipalContext]::new($ct)
                }

                # Use Negotiate so it works for both Kerberos/NTLM where applicable
                return $pc.ValidateCredentials($usernameToValidate, $p, [System.DirectoryServices.AccountManagement.ContextOptions]::Negotiate)
            }
            catch {
                return $false
            }
        }

        switch ($Context) {
            'Local'  { return (Test-WithContext -Which Local) }
            'Domain' { return (Test-WithContext -Which Domain) }
            'Auto' {
                # If user explicitly indicates local, prefer local
                if ($parsed.Qualifier -eq '.' -or $parsed.Qualifier -eq $machineName) {
                    return (Test-WithContext -Which Local)
                }
                # If user indicates a domain or UPN, prefer domain
                if (($parsed.Qualifier -and $parsed.Qualifier -ne '.' -and $parsed.Qualifier -ne $machineName) -or $parsed.IsUPN) {
                    return (Test-WithContext -Which Domain)
                }

                # Otherwise: try Domain first (typical enterprise expectation), then Local fallback
                $ok = Test-WithContext -Which Domain
                if ($ok) { return $true }
                return (Test-WithContext -Which Local)
            }
        }
    }
}