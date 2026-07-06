function Get-VaultWardenFingerprint {
    <#
        .SYNOPSIS
        Retrieves the fingerprint phrase for a user.

        .DESCRIPTION
        Returns the fingerprint phrase for a given user. The fingerprint phrase is used
        to verify a user's identity before confirming organization membership.

        .PARAMETER UserId
        The UUID of the user to look up. Defaults to 'me' for the authenticated user.

        .EXAMPLE
        Get-VaultWardenFingerprint

        .EXAMPLE
        Get-VaultWardenFingerprint -UserId 'some-user-uuid'
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter()]
        [string]$UserId = 'me'
    )

    # bw get fingerprint returns {"object":"fingerprint","fingerprint":"word-word-word-word-word"}
    (Invoke-BW get fingerprint $UserId).fingerprint
}
