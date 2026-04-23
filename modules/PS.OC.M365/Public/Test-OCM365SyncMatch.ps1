function Test-OCM365SyncMatch {
    [CmdletBinding(DefaultParameterSetName="SoftMatch")]
    param (
        [Parameter(ParameterSetName="SoftMatch")]
        [switch]
        $CheckSoftMatch,
        [Parameter(ParameterSetName="HardMatch")]
        [switch]
        $CheckHardMatch,

        [Parameter()]
        [string]
        $UserPrincipalName
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
        $SyncFeatures = Get-OCM365SynchronizationFeature
        $SoftMatchBlocked = $SyncFeatures.BlockSoftMatchEnabled
        if($SoftMatchBlocked) {
            Write-Warning "Soft match is blocked. And Entra ID Connect will not be able to perform soft match operations automatically."
        }
        $HardMatchBlocked = $SyncFeatures.BlockCloudObjectTakeoverThroughHardMatchEnabled
        if($HardMatchBlocked) {
            Write-Warning "Hard match is blocked. And Entra ID Connect will not be able to perform hard match operations automatically."
        }
    }
    process {

    }
}