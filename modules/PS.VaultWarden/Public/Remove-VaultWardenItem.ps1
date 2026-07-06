function Remove-VaultWardenItem {
    <#
        .SYNOPSIS
        Deletes a vault item.

        .DESCRIPTION
        Sends a vault item to the trash by default, where it can be recovered for 30 days.
        Use -Permanent to delete irrecoverably.

        .PARAMETER Id
        The UUID of the item to delete.

        .PARAMETER Permanent
        When specified, permanently deletes the item. This cannot be undone.

        .EXAMPLE
        Remove-VaultWardenItem -Id 'abc123'

        .EXAMPLE
        Remove-VaultWardenItem -Id 'abc123' -Permanent
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id,

        [Parameter()]
        [switch]$Permanent
    )

    process {
        $action = if ($Permanent) { 'Permanently delete vault item' } else { 'Send vault item to trash' }
        if ($PSCmdlet.ShouldProcess($Id, $action)) {
            $bwArgs = [System.Collections.Generic.List[string]]@('delete', 'item', $Id)
            if ($Permanent) { $bwArgs.Add('--permanent') }
            Invoke-BW @bwArgs | Out-Null
        }
    }
}
