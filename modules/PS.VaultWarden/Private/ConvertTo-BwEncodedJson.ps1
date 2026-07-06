function ConvertTo-BwEncodedJson {
    <#
        .SYNOPSIS
        Base64-encodes a PowerShell object as compact JSON for use with bw create/edit commands.

        .DESCRIPTION
        The Bitwarden CLI requires objects passed to create and edit commands to be
        UTF-8 encoded as compact JSON and then Base64 encoded.

        .PARAMETER InputObject
        The object or hashtable to encode.

        .EXAMPLE
        $encoded = ConvertTo-BwEncodedJson -InputObject $itemHashtable
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object]$InputObject
    )

    process {
        $json = $InputObject | ConvertTo-Json -Depth 10 -Compress
        [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($json))
    }
}
