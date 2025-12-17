function Convert-GitLog {
    <#
        .SYNOPSIS
            Parse raw `git log` output into PSCustomObjects.

        .EXAMPLE
            git log | Convert-GitLog

        .NOTES
            Designed for the default multi-line format that starts every commit
            block with the literal string “commit <SHA>”.
    #>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string] $Line
    )

    begin {
        $buffer  = [System.Text.StringBuilder]::new()
        $objects = @()
    }

    process {
        # A blank pipeline element sneaks in at the end of Get-Content sometimes
        if ($null -ne $Line) {
            # If we meet a new "commit ..." line we have finished the previous one
            if ($Line -match '^commit\s+[0-9a-f]{40}$' -and $buffer.Length) {

                $objects += Parse-GitBlock $buffer.ToString()
                $buffer.Clear() | Out-Null
            }

            $null = $buffer.AppendLine($Line)
        }
    }

    end {
        if ($buffer.Length) {
            $objects += Parse-GitBlock $buffer.ToString()
        }

        Write-Output $objects
    }
}