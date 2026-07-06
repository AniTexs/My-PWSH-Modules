function Restore-VaultWardenItem {
    <#
        .SYNOPSIS
        Restores a deleted vault item from the trash.

        .PARAMETER Id
        The UUID of the item to restore.

        .EXAMPLE
        Restore-VaultWardenItem -Id 'abc123'

        .EXAMPLE
        Get-VaultWardenItem -Trash | Where-Object name -eq 'OldLogin' | Restore-VaultWardenItem
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess($Id, 'Restore vault item from trash')) {
            Invoke-BW restore item $Id
        }
    }
}
