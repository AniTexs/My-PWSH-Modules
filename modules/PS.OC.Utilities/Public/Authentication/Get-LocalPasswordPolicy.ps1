function Get-LocalPasswordPolicy {
    <#
    .SYNOPSIS
    Retrieves the local password policy settings from the Windows security database.
    
    .DESCRIPTION
    This function exports the local security policy using secedit.exe and parses the
    password-related settings from the [System Access] section. It returns information
    about minimum password length, complexity requirements, password history, and
    password age constraints.
    
    The function requires administrative privileges to successfully export the security policy.
    If run without admin rights, it will return an error with a helpful hint.
    
    .EXAMPLE
    Get-LocalPasswordPolicy
    
    Retrieves the local password policy settings and displays them as a custom object.
    
    .EXAMPLE
    $policy = Get-LocalPasswordPolicy
    if ($policy.Success) {
        Write-Host "Minimum Password Length: $($policy.MinimumPasswordLength)"
        Write-Host "Password Complexity Enabled: $($policy.PasswordComplexity)"
    }
    
    Retrieves the policy and checks if the operation was successful before accessing properties.
    
    .OUTPUTS
    PSCustomObject
    Returns an object with the following properties:
    - Success: Boolean indicating if the export was successful
    - Scope: Always 'Local' for this function
    - MinimumPasswordLength: Minimum number of characters required
    - PasswordComplexity: Boolean indicating if complexity is enforced
    - PasswordHistorySize: Number of previous passwords remembered
    - MaximumPasswordAgeDays: Maximum number of days before password must be changed
    - MinimumPasswordAgeDays: Minimum number of days before password can be changed
    - Raw: Hashtable of all parsed key-value pairs from [System Access]
    - Error: Error message if Success is false
    - Hint: Helpful hint for troubleshooting if Success is false
    - ExitCode: Exit code from secedit.exe
    
    .NOTES
    Requires administrative privileges to export local security policy.
    Uses secedit.exe which is available on Windows systems.
    Creates a temporary file in $env:TEMP that is automatically cleaned up.
    #>
    [CmdletBinding()]
    param()

    # Generate a unique temporary file path for the security policy export
    $temp = Join-Path $env:TEMP ("secpol_{0}.inf" -f ([guid]::NewGuid()))
    
    try {
        # Export the local security policy to a temporary INI-style file
        # /export = export security configuration
        # /cfg = specify configuration file path
        # /quiet = suppress output
        $p = Start-Process -FilePath secedit.exe -ArgumentList @('/export', '/cfg', $temp, '/quiet') -NoNewWindow -PassThru -Wait -ErrorAction Stop

        # Check if the export failed or the file wasn't created
        if ($p.ExitCode -ne 0 -or -not (Test-Path $temp)) {
            # Determine if the current user has administrative privileges
            $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
                       ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

            # Provide context-appropriate troubleshooting hint
            $hint = if (-not $isAdmin) {
                "Try running PowerShell as Administrator."
            } else {
                "secedit returned ExitCode $($p.ExitCode). Check local security database access and policies."
            }

            # Return error object with diagnostic information
            return [pscustomobject]@{
                Success      = $false
                Scope        = 'Local'
                Error        = "Unable to export Local Security Policy with secedit."
                Hint         = $hint
                ExitCode     = $p.ExitCode
                MinimumPasswordLength = $null
                PasswordComplexity    = $null
                PasswordHistorySize   = $null
                MaximumPasswordAgeDays= $null
                MinimumPasswordAgeDays= $null
                Raw          = $null
            }
        }

        # Read the exported security policy file
        $lines = Get-Content -LiteralPath $temp -ErrorAction Stop

        # Locate the [System Access] section which contains password policy settings
        $start = ($lines | Select-String -SimpleMatch '[System Access]' | Select-Object -First 1).LineNumber
        if (-not $start) {
            # [System Access] section not found - unexpected situation
            return [pscustomobject]@{
                Success = $false
                Scope   = 'Local'
                Error   = "Export succeeded but [System Access] section was not found."
                Hint    = "This is unusual; the export format may have changed or the file is truncated."
                ExitCode= $p.ExitCode
                Raw     = $null
            }
        }

        # Extract the [System Access] section content
        $section = $lines[($start)..($lines.Length-1)]
        
        # Find where this section ends (next section header or end of file)
        $nextHeader = ($section | Select-String '^\s*\[.+\]\s*$' | Select-Object -Skip 1 -First 1)
        if ($nextHeader) {
            $section = $section[0..($nextHeader.LineNumber-2)]
        }

        # Parse the section into a hashtable of key-value pairs
        # Format: Key = Value (ignoring lines starting with semicolon comments)
        $kv = @{}
        foreach ($l in $section) {
            # Match lines with pattern "Key = Value" (not starting with semicolon)
            if ($l -match '^\s*(?<k>[^;][^=]+?)\s*=\s*(?<v>.*)\s*$') {
                $kv[$Matches.k.Trim()] = $Matches.v.Trim()
            }
        }

        # Helper scriptblock to safely convert string values to integers
        $toInt = { param($x) if ([string]::IsNullOrWhiteSpace($x)) { $null } else { [int]$x } }

        # Return success object with parsed password policy settings
        return [pscustomobject]@{
            Success      = $true
            Scope        = 'Local'
            MinimumPasswordLength = & $toInt $kv['MinimumPasswordLength']  # Minimum characters required
            PasswordComplexity    = ((& $toInt $kv['PasswordComplexity']) -eq 1)  # 1=enabled, 0=disabled
            PasswordHistorySize   = & $toInt $kv['PasswordHistorySize']  # Number of passwords remembered
            MaximumPasswordAgeDays= & $toInt $kv['MaximumPasswordAge']  # Days until password expires
            MinimumPasswordAgeDays= & $toInt $kv['MinimumPasswordAge']  # Days before password can be changed
            Raw          = $kv  # All parsed key-value pairs for advanced scenarios
        }
    }
    catch {
        # Handle any unexpected errors during export or parsing
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
                   ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        $hint = if (-not $isAdmin) { "Try running PowerShell as Administrator." } else { "Check secedit availability and local security database permissions." }

        return [pscustomobject]@{
            Success      = $false
            Scope        = 'Local'
            Error        = $_.Exception.Message
            Hint         = $hint
            ExitCode     = $null
            MinimumPasswordLength = $null
            PasswordComplexity    = $null
            PasswordHistorySize   = $null
            MaximumPasswordAgeDays= $null
            MinimumPasswordAgeDays= $null
            Raw          = $null
        }
    }
    finally {
        # Always clean up the temporary file, even if an error occurred
        Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
    }
}
