function Set-GWToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [SecureString]
        $Token
    )
    $Script:GWToken = $Token
}