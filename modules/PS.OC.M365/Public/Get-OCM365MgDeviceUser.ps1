function Get-OCM365MgDeviceUser {
    <#
        .SYNOPSIS
        Resolves the Microsoft 365 user associated with a device.

        .DESCRIPTION
        Looks up the matching Intune managed device and Windows Autopilot device for an
        Entra device, then returns the best available `UserPrincipalName` together with
        the resolved Microsoft Graph user object.

        .PARAMETER Device
        A Microsoft Graph device object.

        .PARAMETER DeviceId
        The Entra device `deviceId` value.

        .PARAMETER ManagedDeviceId
        The Intune managed device id, for example from an Autopilot device's
        `ManagedDeviceId` property.

        .PARAMETER Id
        The Intune managed device `Id` value.

        .EXAMPLE
        Get-MgDevice -Search 'displayName:PC01' -ConsistencyLevel eventual | Get-OCM365MgDeviceUser

        .EXAMPLE
        Get-OCM365MgDeviceUser -DeviceId '11111111-1111-1111-1111-111111111111'
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([pscustomobject])]
    param (
        [Parameter(ValueFromPipeline, Mandatory, ParameterSetName = 'InputObject')]
        [Microsoft.Graph.PowerShell.Models.MicrosoftGraphDevice]
        $Device,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory, ParameterSetName = 'Default')]
        [guid]
        $DeviceId,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory, ParameterSetName = 'Intune')]
        [guid]
        $ManagedDeviceId,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory, ParameterSetName = 'Managed')]
        [guid]
        $Id
    )

    begin {
        #region Helper Functions
        function Test-OCM365GraphCommandScope {
            param(
                [Parameter(Mandatory)]
                [string]$CommandName,
                [Parameter(Mandatory)]
                [string[]]$CurrentScopes
            )

            $CommandMetadata = Find-MgGraphCommand -Command $CommandName | Select-Object -First 1
            if (-not $CommandMetadata) {
                return $null
            }

            $PermissionNames = @($CommandMetadata.Permissions.Name | Where-Object { $_ })
            if (-not $PermissionNames) {
                return $null
            }

            if ($PermissionNames | Where-Object { $_ -in $CurrentScopes }) {
                return $null
            }

            return [pscustomobject]@{
                Command     = $CommandName
                Permissions = $PermissionNames
            }
        }

        function Resolve-OCM365ManagedDeviceUserPrincipalName {
            param(
                [Parameter()]$AutopilotDevice,
                [Parameter()]$ManagedDevice
            )

            if ($AutopilotDevice -and $AutopilotDevice.UserPrincipalName) {
                return $AutopilotDevice.UserPrincipalName
            }

            if ($ManagedDevice -and $ManagedDevice.UserPrincipalName) {
                $ResolvedUserPrincipalName = $ManagedDevice.UserPrincipalName
                if ($ManagedDevice.UserId) {
                    $NormalizedUserId = ([string]$ManagedDevice.UserId) -replace '-', ''
                    if ($NormalizedUserId) {
                        $ResolvedUserPrincipalName = $ResolvedUserPrincipalName -replace [regex]::Escape($NormalizedUserId), ''
                    }
                }

                if ($ResolvedUserPrincipalName) {
                    return $ResolvedUserPrincipalName
                }
            }

            if ($ManagedDevice -and $ManagedDevice.EmailAddress) {
                return $ManagedDevice.EmailAddress
            }

            return $null
        }
        #endregion

        #region Graph Permission Check
        $MgCtx = Get-MgContext
        if (-not $MgCtx) {
            throw 'No valid Microsoft Graph context found.'
        }

        $MissingPermissions = @(
            Test-OCM365GraphCommandScope -CommandName 'Get-MgDevice' -CurrentScopes $MgCtx.Scopes
            Test-OCM365GraphCommandScope -CommandName 'Get-MgDeviceManagementManagedDevice' -CurrentScopes $MgCtx.Scopes
            Test-OCM365GraphCommandScope -CommandName 'Get-MgDeviceManagementWindowsAutopilotDeviceIdentity' -CurrentScopes $MgCtx.Scopes
            Test-OCM365GraphCommandScope -CommandName 'Get-MgUser' -CurrentScopes $MgCtx.Scopes
        ) | Where-Object { $_ }

        if ($MissingPermissions.Count -gt 0) {
            $MissingPermissions | ForEach-Object {
                Write-Warning ("Missing permission for {0}: {1}" -f $_.Command, ($_.Permissions -join ', '))
            }

            throw 'Missing permissions'
        }
        #endregion
    }

    process {
        #region Resolve Input
        $ResolvedGraphDevice = $null
        $ResolvedManagedDevice = $null
        $ResolvedAutopilotDevice = $null
        $ResolvedDeviceId = $null

        switch ($PSCmdlet.ParameterSetName) {
            'InputObject' {
                $ResolvedGraphDevice = $Device
                $ResolvedDeviceId = [string]$Device.DeviceId
            }
            'Default' {
                $ResolvedDeviceId = [string]$DeviceId
            }
            'Intune' {
                $ResolvedManagedDevice = Get-MgDeviceManagementManagedDevice -ManagedDeviceId ([string]$ManagedDeviceId) -Property 'id,azureAdDeviceId,deviceName,emailAddress,userId,userPrincipalName' -ErrorAction Stop
                $ResolvedDeviceId = [string]$ResolvedManagedDevice.AzureAdDeviceId
            }
            'Managed' {
                $ResolvedManagedDevice = Get-MgDeviceManagementManagedDevice -ManagedDeviceId ([string]$Id) -Property 'id,azureAdDeviceId,deviceName,emailAddress,userId,userPrincipalName' -ErrorAction Stop
                $ResolvedDeviceId = [string]$ResolvedManagedDevice.AzureAdDeviceId
            }
        }
        #endregion

        #region Resolve Device Objects
        if (-not $ResolvedGraphDevice -and $ResolvedDeviceId) {
            $ResolvedGraphDevice = Get-MgDevice -Filter "deviceId eq '$ResolvedDeviceId'" -ConsistencyLevel eventual -Property 'id,deviceId,displayName' -ErrorAction SilentlyContinue | Select-Object -First 1
        }

        if (-not $ResolvedManagedDevice -and $ResolvedDeviceId) {
            $ResolvedManagedDevice = Get-MgDeviceManagementManagedDevice -Filter "azureAdDeviceId eq '$ResolvedDeviceId'" -Property 'id,azureAdDeviceId,deviceName,emailAddress,userId,userPrincipalName' -ErrorAction SilentlyContinue | Select-Object -First 1
        }

        if ($ResolvedManagedDevice -and $ResolvedManagedDevice.Id) {
            $ResolvedAutopilotDevice = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -Filter "managedDeviceId eq '$($ResolvedManagedDevice.Id)'" -Property 'id,managedDeviceId,azureActiveDirectoryDeviceId,userPrincipalName,displayName' -ErrorAction SilentlyContinue | Select-Object -First 1
        }

        if (-not $ResolvedAutopilotDevice -and $ResolvedDeviceId) {
            $ResolvedAutopilotDevice = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -Filter "azureActiveDirectoryDeviceId eq '$ResolvedDeviceId'" -Property 'id,managedDeviceId,azureActiveDirectoryDeviceId,userPrincipalName,displayName' -ErrorAction SilentlyContinue | Select-Object -First 1
        }
        #endregion

        #region Resolve User
        $ResolvedUserPrincipalName = Resolve-OCM365ManagedDeviceUserPrincipalName -AutopilotDevice $ResolvedAutopilotDevice -ManagedDevice $ResolvedManagedDevice

        $ResolvedMgUser = $null
        if ($ResolvedUserPrincipalName) {
            try {
                $ResolvedMgUser = Get-MgUser -UserId $ResolvedUserPrincipalName -Property 'id,displayName,userPrincipalName,mail' -ErrorAction Stop
            }
            catch {
                Write-Verbose "Unable to resolve Microsoft Graph user by UserPrincipalName '$ResolvedUserPrincipalName'."
            }
        }

        if (-not $ResolvedMgUser -and $ResolvedManagedDevice -and $ResolvedManagedDevice.UserId) {
            try {
                $ResolvedMgUser = Get-MgUser -UserId ([string]$ResolvedManagedDevice.UserId) -Property 'id,displayName,userPrincipalName,mail' -ErrorAction Stop
            }
            catch {
                Write-Verbose "Unable to resolve Microsoft Graph user by UserId '$($ResolvedManagedDevice.UserId)'."
            }
        }

        if (-not $ResolvedUserPrincipalName -and $ResolvedMgUser -and $ResolvedMgUser.UserPrincipalName) {
            $ResolvedUserPrincipalName = $ResolvedMgUser.UserPrincipalName
        }
        #endregion

        [pscustomobject][ordered]@{
            UserPrincipalName = $ResolvedUserPrincipalName
            MgUser            = $ResolvedMgUser
            Device            = $ResolvedGraphDevice
            ManagedDevice     = $ResolvedManagedDevice
            AutopilotDevice   = $ResolvedAutopilotDevice
        }
    }
}
