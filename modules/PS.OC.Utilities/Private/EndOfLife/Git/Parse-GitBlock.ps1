function Parse-GitBlock {
    param([string]$Text)

    # Commit SHA
    $commit = ($Text -split "`n")[0] -replace '^commit\s+'

    # Author
    if ($Text -match '(?m)^Author:\s+(.+?)\s+<(.+?)>') {
        $author = $matches[1].Trim()
        $email  = $matches[2].Trim()
    }

    # --- robust Date handling --------------------------------------------
    if ($Text -match '(?m)^Date:\s+(.+)$') {

        # Raw string straight from git
        $rawDate = $matches[1].Trim()

        # Convert “-0700 / +0200” ➜ “-07:00 / +02:00” (add colon so .NET accepts it)
        $rawDate = $rawDate -replace '([+-]\d{2})(\d{2})$','$1:$2'

        # One exact pattern is enough; “d” handles 1- or 2-digit days
        $pattern = 'ddd MMM d HH:mm:ss yyyy zzz'

        try {
            $date = [DateTimeOffset]::ParseExact(
                        $rawDate,
                        $pattern,
                        [System.Globalization.CultureInfo]::InvariantCulture,
                        [System.Globalization.DateTimeStyles]::None)
        } catch {
            $date = $null      # still return object even if parsing fails
        }
    }
    # ----------------------------------------------------------------------

    # Commit message (indented by four spaces)
    $msg = ($Text -split "`r?`n") |
           Where-Object { $_ -match '^\s{4}.+' } |
           ForEach-Object { $_.Trim() } |
           Where-Object { $_ } |
           Out-String

    [pscustomobject]@{
        Commit  = $commit
        Author  = $author
        Email   = $email
        Date    = $date         # [DateTimeOffset] with correct TZ
        Message = $msg.Trim()
    }
}