function Set-PWSTContext {
    param(
        [String]$BaseUrl,
        [String]$ApiKey,
        [int]$PasswordListId,
        [bool]$VerifySsl = $true,
        [int]$TimeoutSec = 30
    )
    $ctx = @{
        BaseUrl        = $BaseUrl  # e.g. https://pwstate.mycorp.com
        ApiKey         = $ApiKey   # Passwordstate API key
        PasswordListId = $PasswordListId
        VerifySsl      = $VerifySsl
        TimeoutSec     = $TimeoutSec ?? 30
    }
    foreach ($k in 'BaseUrl','ApiKey','PasswordListId') {
        if (-not $ctx[$k]) { throw "Missing required VaultParameter '$k'." }
    }
    # Make sure PasswordListId is an integer
    if($ctx.PasswordListId -isnot [int]) {
        try {
            $ctx.PasswordListId = [int]$ctx.PasswordListId
        }
        catch {
            throw "'PasswordListId' must be an integer."
        }
        
    }
    if ($ctx.BaseUrl.EndsWith('/')) { $ctx.BaseUrl = $ctx.BaseUrl.TrimEnd('/') }
    $Script:PWST_Context = $ctx
    return $Script:PWST_Context
}