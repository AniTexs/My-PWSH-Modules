function Invoke-BW {
    <#
        .SYNOPSIS
        Wrapper for the Bitwarden CLI (bw.exe).

        .DESCRIPTION
        Invokes the Bitwarden CLI with the given arguments, automatically appending --response
        and converting the JSON output into a PowerShell object. Throws a terminating error if
        the CLI reports failure.

        .PARAMETER ArgumentList
        One or more arguments to pass directly to the Bitwarden CLI
        (e.g. 'list', 'items', '--search', 'mysite').

        .EXAMPLE
        Invoke-BW status

        .EXAMPLE
        Invoke-BW list items --search "mysite"

        .EXAMPLE
        Invoke-BW unlock --passwordenv BW_MASTERPASSWORD --raw
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromRemainingArguments)]
        [string[]]$ArgumentList
    )

    $bwExe = Join-Path $PSScriptRoot 'bw-win\bw.exe'

    # Build the argument list. Append --session when a session key is available so that
    # the vault can be accessed even when it is internally locked (bw v1.22.1 on Windows
    # does not reliably read BW_SESSION from the environment without an explicit flag).
    $bwCallArgs = [System.Collections.Generic.List[string]]$ArgumentList
    if ($env:BW_SESSION) {
        $bwCallArgs.AddRange([string[]]@('--session', $env:BW_SESSION))
    }

    # Merge stderr into the output stream so we can inspect and filter it.
    # Stderr lines come back as [ErrorRecord] objects; stdout lines are plain strings.
    # --nointeraction prevents bw from blocking on interactive prompts (e.g. master password).
    $stdErr = [System.Collections.Generic.List[string]]::new()
    $stdout = & $bwExe @bwCallArgs --response --nointeraction 2>&1 | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            $stdErr.Add($_.Exception.Message)
        }
        else {
            $_
        }
    }

    # Suppress known CLI noise; surface anything else as a warning.
    foreach ($errLine in $stdErr) {
        if ($errLine -notmatch 'mac failed') {
            Write-Warning "bw stderr: $errLine"
        }
    }

    $response = $stdout | ConvertFrom-Json

    if (-not $response.success) {
        # Error shape varies: data.message or data.title + data.message
        $errorMessage = if ($response.data) {
            "$($response.data.title) $($response.data.message)".Trim()
        }
        else {
            $response.message
        }
        # Guard against a null/empty message producing an opaque 'ScriptHalted' error.
        if ([string]::IsNullOrWhiteSpace($errorMessage)) {
            $errorMessage = "Bitwarden CLI reported failure for command: bw $ArgumentList"
        }
        throw $errorMessage
    }

    return $response.data
}
