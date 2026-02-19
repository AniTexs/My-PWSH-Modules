function Test-PasswordComplexity {
    <#
        .SYNOPSIS
        Validates password length and complexity against AD policy.

        .DESCRIPTION
        Evaluates a SecureString password for minimum length and character
        category complexity. If a user is provided and a Fine-Grained Password
        Policy (PSO) applies, that policy is used; otherwise the default domain
        password policy is used.

        .PARAMETER Password
        The password to evaluate as a SecureString.

        .PARAMETER User
        Optional user identifier (samAccountName, DN, or UPN) used to resolve
        the effective password policy (PSO) for that user.

        .PARAMETER RequiredCategories
        The minimum number of character categories required when complexity is
        enabled. Default is 3 (Windows default).

        .EXAMPLE
        $secure = Read-Host -AsSecureString "Password"
        Test-PasswordComplexity -Password $secure

        .EXAMPLE
        $secure = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
        Test-PasswordComplexity -Password $secure -User "jdoe"

        .OUTPUTS
        PSCustomObject with compliance details and policy metadata.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [SecureString] $Password,

        # Optional: if you pass a user (samAccountName, DN, UPN),
        # we’ll use Fine-Grained Password Policy (PSO) when present.
        [Parameter()]
        [string] $User,

        # Default Windows complexity rule is 3 of 4 categories.
        [ValidateRange(1,4)]
        [int] $RequiredCategories = 3
    )

    begin {
        # Helper: get effective policy (PSO if User is provided and has one)
        function Get-EffectivePasswordPolicy {
            param([string] $User)

            if ($User) {
                try {
                    # Get-ADUserResultantPasswordPolicy returns the effective policy (PSO) if applicable.
                    $pso = Get-ADUserResultantPasswordPolicy -Identity $User -ErrorAction Stop
                    if ($pso) {
                        return [pscustomobject]@{
                            PolicySource        = "PSO"
                            Name                = $pso.Name
                            MinPasswordLength   = $pso.MinPasswordLength
                            ComplexityEnabled   = $pso.ComplexityEnabled
                        }
                    }
                } catch {
                    # If we can’t resolve PSO, fall back to default domain policy
                }
            }

            $d = Get-ADDefaultDomainPasswordPolicy
            [pscustomobject]@{
                PolicySource        = "DefaultDomain"
                Name                = $d.Name
                MinPasswordLength   = $d.MinPasswordLength
                ComplexityEnabled   = $d.ComplexityEnabled
            }
        }
    }

    process {
        $policy = Get-EffectivePasswordPolicy -User $User

        # Convert SecureString -> plaintext (unfortunately needed for regex checks)
        $plain = (New-Object PSCredential 'x', $Password).GetNetworkCredential().Password

        try {
            $lenOk = ($plain.Length -ge $policy.MinPasswordLength)

            # Character category checks (Unicode-aware-ish: upper/lower relies on .NET char properties)
            $hasLower   = $plain -cmatch '\p{Ll}'
            $hasUpper   = $plain -cmatch '\p{Lu}'
            $hasDigit   = $plain -cmatch '\p{Nd}'
            # “Special” = not letter or digit
            $hasSpecial = $plain -cmatch '[^\p{L}\p{Nd}]'

            $met = @(
                [pscustomobject]@{ Name = 'Lower';   Met = [bool]$hasLower }
                [pscustomobject]@{ Name = 'Upper';   Met = [bool]$hasUpper }
                [pscustomobject]@{ Name = 'Digit';   Met = [bool]$hasDigit }
                [pscustomobject]@{ Name = 'Special'; Met = [bool]$hasSpecial }
            )

            $categoryCount = ($met | Where-Object Met).Count
            $complexityOk  = if ($policy.ComplexityEnabled) { $categoryCount -ge $RequiredCategories } else { $true }

            $isCompliant = $lenOk -and $complexityOk

            [pscustomobject]@{
                IsCompliant         = $isCompliant
                PolicySource        = $policy.PolicySource
                PolicyName          = $policy.Name
                MinPasswordLength   = $policy.MinPasswordLength
                ComplexityEnabled   = $policy.ComplexityEnabled
                RequiredCategories  = if ($policy.ComplexityEnabled) { $RequiredCategories } else { 0 }
                CategoryCount       = $categoryCount
                CategoriesMet       = ($met | Where-Object Met | Select-Object -ExpandProperty Name)
                CategoriesMissing   = ($met | Where-Object { -not $_.Met } | Select-Object -ExpandProperty Name)
                Length              = $plain.Length
                LengthOk            = $lenOk
                ComplexityOk        = $complexityOk
            }
        }
        finally {
            # Best-effort reduce lifetime of plaintext in memory
            $plain = $null
        }
    }
}