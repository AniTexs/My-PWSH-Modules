function Get-OCM365SynchronizationFeature {
    param (
        [Parameter()]
        [string]
        $OptionalParameters
    )
    begin {
        # Validate a graph connection valid
        $mgCtx = Get-MgContext
        if (-not $mgCtx) {
            throw "No valid Microsoft Graph context found."
        }
        # Validate either OnPremDirectorySynchronization.ReadWrite.All or OnPremDirectorySynchronization.Read.All is in scope
        if (-not ($mgCtx.Scopes -contains "OnPremDirectorySynchronization.ReadWrite.All" -or $mgCtx.Scopes -contains "OnPremDirectorySynchronization.Read.All")) {
            throw @"
Missing Required Graph permissions.

'OnPremDirectorySynchronization.ReadWrite.All' or 
'OnPremDirectorySynchronization.Read.All' permission is required. 
And is not granted in current Graph connection context.

run 'Connect-MgGraph -Scopes "OnPremDirectorySynchronization.Read.All"' to grant the required permissions.
"@
        }
    }
    process {
        $OnPremSync = Get-MgDirectoryOnPremiseSynchronization
        return $OnPremSync.Features
    }
}