function Sync-VaultWarden {
    <#
        .SYNOPSIS
        Synchronizes the local vault cache with the Bitwarden server.

        .DESCRIPTION
        Downloads the latest encrypted vault data from the server. Run this after making
        changes in another Bitwarden client (web vault, browser extension, mobile app)
        to make those changes available in the CLI session.

        .PARAMETER Last
        When specified, returns the ISO 8601 timestamp of the last successful sync
        instead of performing a new sync.

        .EXAMPLE
        Sync-VaultWarden

        .EXAMPLE
        Sync-VaultWarden -Last
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]$Last
    )

    if ($Last) {
        # Returns {"object":"string","data":"2020-06-16T06:33:51.419Z"}
        (Invoke-BW sync --last).data
    }
    else {
        Invoke-BW sync | Out-Null
        Write-Verbose 'Vault synchronized successfully.'
    }
}
