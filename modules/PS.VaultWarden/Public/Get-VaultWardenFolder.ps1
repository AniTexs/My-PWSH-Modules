function Get-VaultWardenFolder {
    <#
        .SYNOPSIS
        Retrieves a single vault folder or a list of all folders.

        .DESCRIPTION
        When -Id is provided, returns a single folder by UUID or search term.
        Without -Id, returns all folders in the vault.

        .PARAMETER Id
        UUID or search term for a single folder.

        .EXAMPLE
        Get-VaultWardenFolder

        .EXAMPLE
        Get-VaultWardenFolder -Id 'Work'
    #>
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single', Position = 0)]
        [string]$Id
    )

    if ($PSCmdlet.ParameterSetName -eq 'Single') {
        Invoke-BW get folder $Id
    }
    else {
        (Invoke-BW list folders).data
    }
}
