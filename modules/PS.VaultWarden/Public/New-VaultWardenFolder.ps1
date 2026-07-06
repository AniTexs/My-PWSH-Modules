function New-VaultWardenFolder {
    <#
        .SYNOPSIS
        Creates a new vault folder.

        .PARAMETER Name
        The name for the new folder.

        .EXAMPLE
        New-VaultWardenFolder -Name 'Work'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Name
    )

    if ($PSCmdlet.ShouldProcess($Name, 'Create vault folder')) {
        $encoded = ConvertTo-BwEncodedJson -InputObject @{ name = $Name }
        Invoke-BW create folder $encoded
    }
}
