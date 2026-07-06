function Remove-VaultWardenFolder {
    <#
        .SYNOPSIS
        Deletes a vault folder.

        .PARAMETER Id
        The UUID of the folder to delete.

        .EXAMPLE
        Remove-VaultWardenFolder -Id 'abc123'
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]$Id
    )

    process {
        if ($PSCmdlet.ShouldProcess($Id, 'Delete vault folder')) {
            Invoke-BW delete folder $Id | Out-Null
        }
    }
}
