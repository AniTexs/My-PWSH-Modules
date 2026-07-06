function New-VaultWardenPassword {
    <#
        .SYNOPSIS
        Generates a strong random password or passphrase.

        .DESCRIPTION
        Wraps the Bitwarden CLI 'generate' command. By default generates a 14-character
        password with uppercase, lowercase, and numbers.

        .PARAMETER Length
        Length of the generated password. Minimum 5. Default 14.

        .PARAMETER Uppercase
        Include uppercase letters.

        .PARAMETER Lowercase
        Include lowercase letters.

        .PARAMETER Number
        Include numbers.

        .PARAMETER Special
        Include special characters.

        .PARAMETER Passphrase
        Generate a passphrase instead of a password.

        .PARAMETER Words
        Number of words in the passphrase. Used with -Passphrase. Default 3.

        .PARAMETER Separator
        Word separator character. Used with -Passphrase. Default '-'.

        .PARAMETER Capitalize
        Title-case the passphrase words. Used with -Passphrase.

        .PARAMETER IncludeNumber
        Include a single number in the passphrase. Used with -Passphrase.

        .EXAMPLE
        New-VaultWardenPassword

        .EXAMPLE
        New-VaultWardenPassword -Length 20 -Uppercase -Lowercase -Number -Special

        .EXAMPLE
        New-VaultWardenPassword -Passphrase -Words 4 -Capitalize
    #>
    [CmdletBinding(DefaultParameterSetName = 'Password')]
    [OutputType([string])]
    param (
        [Parameter(ParameterSetName = 'Password')]
        [ValidateRange(5, 128)]
        [int]$Length = 14,

        [Parameter(ParameterSetName = 'Password')]
        [switch]$Uppercase,

        [Parameter(ParameterSetName = 'Password')]
        [switch]$Lowercase,

        [Parameter(ParameterSetName = 'Password')]
        [switch]$Number,

        [Parameter(ParameterSetName = 'Password')]
        [switch]$Special,

        [Parameter(Mandatory, ParameterSetName = 'Passphrase')]
        [switch]$Passphrase,

        [Parameter(ParameterSetName = 'Passphrase')]
        [ValidateRange(3, 20)]
        [int]$Words = 3,

        [Parameter(ParameterSetName = 'Passphrase')]
        [string]$Separator = '-',

        [Parameter(ParameterSetName = 'Passphrase')]
        [switch]$Capitalize,

        [Parameter(ParameterSetName = 'Passphrase')]
        [switch]$IncludeNumber
    )

    $bwArgs = [System.Collections.Generic.List[string]]@('generate')

    if ($PSCmdlet.ParameterSetName -eq 'Passphrase') {
        $bwArgs.Add('--passphrase')
        $bwArgs.AddRange([string[]]@('--words', $Words))
        $bwArgs.AddRange([string[]]@('--separator', $Separator))
        if ($Capitalize)    { $bwArgs.Add('--capitalize') }
        if ($IncludeNumber) { $bwArgs.Add('--includeNumber') }
    }
    else {
        $bwArgs.AddRange([string[]]@('--length', $Length))
        if ($Uppercase) { $bwArgs.Add('--uppercase') }
        if ($Lowercase) { $bwArgs.Add('--lowercase') }
        if ($Number)    { $bwArgs.Add('--number') }
        if ($Special)   { $bwArgs.Add('--special') }
    }

    # bw generate returns {"object":"string","data":"generatedvalue"}
    (Invoke-BW @bwArgs).data
}
