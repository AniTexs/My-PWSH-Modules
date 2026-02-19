function New-ACardCodeBlock {
    [CmdletBinding()]
    param (
        [string]
        $Id,
        [Parameter(Mandatory)]
        [string]
        $Code,
        [PS.AdaptiveCard.Code+Language]
        $Language = [PS.AdaptiveCard.Code+Language]::PlainText,
        [int]
        $StartLineNumber = 1
    )
    $ret = @{
        type            = "CodeBlock"
        language        = $Language.ToString()
        codeSnippet     = $Code
        startLineNumber = $StartLineNumber
    }
    if ($Id) { $ret.id = $Id }
    $ret
}