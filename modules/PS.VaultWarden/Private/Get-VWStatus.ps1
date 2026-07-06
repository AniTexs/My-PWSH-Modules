function Get-VWStatus {
    <#
        .SYNOPSIS
        Returns the Bitwarden CLI status object.

        .DESCRIPTION
        Returns a status object with serverUrl, lastSync, userEmail, userId, and status fields.
        Status is one of: 'unlocked', 'locked', 'unauthenticated'.
    #>
    [CmdletBinding()]
    param()

    # bw status --response wraps the status in data.template
    (Invoke-BW status).template
}
