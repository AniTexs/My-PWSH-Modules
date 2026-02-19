function Test-LocalPasswordComplexity {
    <#
        .SYNOPSIS
        Tests a password against the local password policy for complexity requirements.

        .DESCRIPTION
        Validates whether a given password meets the local system's password policy requirements,
        including minimum length and character complexity. The function checks for the presence of
        lowercase letters, uppercase letters, digits, and special characters. Returns detailed
        information about compliance and which requirements are met.

        .PARAMETER Password
        The password to test, provided as a SecureString for security. Accepts pipeline input.

        .PARAMETER RequiredCategories
        The number of character categories (lowercase, uppercase, digit, special) required for
        complexity compliance. Valid range is 1-4. Default is 3.
        Only enforced if the local password complexity policy is enabled.

        .EXAMPLE
        $securePassword = ConvertTo-SecureString 'MyP@ssw0rd!' -AsPlainText -Force
        Test-LocalPasswordComplexity -Password $securePassword

        Tests if the password 'MyP@ssw0rd!' meets the local password policy requirements.

        .EXAMPLE
        ConvertTo-SecureString 'weakpass' -AsPlainText -Force | Test-LocalPasswordComplexity

        Tests a weak password using pipeline input and returns compliance details.

        .EXAMPLE
        $securePassword = ConvertTo-SecureString 'Abc123!@#' -AsPlainText -Force
        Test-LocalPasswordComplexity -Password $securePassword -RequiredCategories 4

        Tests if the password meets all 4 character category requirements.

        .OUTPUTS
        PSCustomObject with the following properties:
        - IsCompliant: Overall compliance status (bool)
        - Scope: Always 'Local' for this function
        - MinPasswordLength: Minimum length required by policy
        - ComplexityEnabled: Whether complexity is enabled in policy (bool)
        - RequiredCategories: Number of categories required
        - CategoryCount: Actual number of categories present in password
        - Length: Actual password length
        - LengthOk: Whether length requirement is met (bool)
        - ComplexityOk: Whether complexity requirement is met (bool)

        .NOTES
        The function uses Unicode character classes for robust pattern matching:
        - \p{Ll}: Lowercase letters
        - \p{Lu}: Uppercase letters
        - \p{Nd}: Decimal digits
        - [^\p{L}\p{Nd}]: Any character that is not a letter or digit (special characters)
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [SecureString] $Password,

        [ValidateRange(1,4)]
        [int] $RequiredCategories = 3
    )

    # Retrieve the current local password policy settings
    $policy = Get-LocalPasswordPolicy

    # Convert SecureString to plain text for analysis
    # Note: This is necessary for validation but we clear it in the finally block
    $plain = (New-Object PSCredential 'x', $Password).GetNetworkCredential().Password
    
    try {
        # Check if password meets minimum length requirement
        # If no minimum length is set in policy, consider it always valid
        $lenOk = if ($policy.MinimumPasswordLength -ne $null) { 
            $plain.Length -ge $policy.MinimumPasswordLength 
        } else { 
            $true 
        }

        # Check for presence of each character category using Unicode character classes
        # \p{Ll} = Unicode lowercase letters
        $hasLower   = $plain -cmatch '\p{Ll}'
        
        # \p{Lu} = Unicode uppercase letters
        $hasUpper   = $plain -cmatch '\p{Lu}'
        
        # \p{Nd} = Unicode decimal digits (0-9)
        $hasDigit   = $plain -cmatch '\p{Nd}'
        
        # [^\p{L}\p{Nd}] = Any character that is NOT a letter or digit (special characters)
        $hasSpecial = $plain -cmatch '[^\p{L}\p{Nd}]'

        # Count how many character categories are present in the password
        $categoryCount = @($hasLower,$hasUpper,$hasDigit,$hasSpecial | Where-Object { $_ }).Count
        
        # Check if complexity requirement is met
        # If complexity is enabled in policy, verify the password has enough categories
        # If complexity is not enabled, automatically pass this check
        $complexityOk  = if ($policy.PasswordComplexity) { 
            $categoryCount -ge $RequiredCategories 
        } else { 
            $true 
        }

        # Return detailed compliance information
        [pscustomobject]@{
            IsCompliant          = $lenOk -and $complexityOk
            Scope                = 'Local'
            MinPasswordLength    = $policy.MinimumPasswordLength
            ComplexityEnabled    = $policy.PasswordComplexity
            RequiredCategories   = if ($policy.PasswordComplexity) { $RequiredCategories } else { 0 }
            CategoryCount        = $categoryCount
            Length               = $plain.Length
            LengthOk             = $lenOk
            ComplexityOk         = $complexityOk
        }
    }
    finally {
        # Security: Clear the plain text password from memory
        $plain = $null
    }
}
