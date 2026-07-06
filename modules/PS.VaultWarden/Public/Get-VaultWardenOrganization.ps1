function Get-VaultWardenOrganization {
    <#
        .SYNOPSIS
        Retrieves all organizations the authenticated user belongs to.

        .EXAMPLE
        Get-VaultWardenOrganization
    #>
    [CmdletBinding()]
    param()

    (Invoke-BW list organizations).data
}
