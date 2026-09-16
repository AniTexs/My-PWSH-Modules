function Install-ModuleToDirectory {
    <#
    .SYNOPSIS
    Installs a PowerShell module into a custom directory, with optional version control, updating, and cleanup of old versions.

    .DESCRIPTION
    Saves a module from the PowerShell Gallery into a specified destination folder. If the module is already present it is left
    untouched unless -Update or a version parameter is supplied, in which case the requested (or latest) version is installed when
    it is not already present. Old versions can optionally be removed from the destination with -RemoveOtherVersions.

    .PARAMETER Name
    The name of the module to install.

    .PARAMETER Destination
    The directory the module should be saved into. Must already exist.

    .PARAMETER Update
    Installs a newer version when one is available for an already-installed module.

    .PARAMETER RequiredVersion
    Installs an exact version of the module. Cannot be combined with -MinimumVersion or -MaximumVersion.

    .PARAMETER MinimumVersion
    The lowest acceptable version of the module.

    .PARAMETER MaximumVersion
    The highest acceptable version of the module.

    .PARAMETER RemoveOtherVersions
    Removes every other version of the module from the destination, keeping only the required or newest version.

    .EXAMPLE
    Install-ModuleToDirectory -Name Pester -Destination 'C:\Modules'

    Installs the latest version of Pester into C:\Modules if it is not already present.

    .EXAMPLE
    Install-ModuleToDirectory -Name Pester -Destination 'C:\Modules' -Update -RemoveOtherVersions

    Updates Pester to the latest version and removes any older versions from the destination.

    .EXAMPLE
    Install-ModuleToDirectory -Name Pester -Destination 'C:\Modules' -RequiredVersion '5.5.0'

    Installs exactly version 5.5.0 of Pester.

    .NOTES
    Modules are sourced from the PSGallery repository.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $true)]
    [OutputType('System.Management.Automation.PSModuleInfo')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [ValidateNotNullOrEmpty()]
        $Destination,

        [Parameter()]
        [switch]
        $Update,

        [Parameter(ParameterSetName = 'RequiredVersion')]
        [ValidateNotNullOrEmpty()]
        [string]
        $RequiredVersion,

        [Parameter(ParameterSetName = 'VersionRange')]
        [ValidateNotNullOrEmpty()]
        [string]
        $MinimumVersion,

        [Parameter(ParameterSetName = 'VersionRange')]
        [ValidateNotNullOrEmpty()]
        [string]
        $MaximumVersion,

        [Parameter()]
        [switch]
        $RemoveOtherVersions
    )

    # Enumerates the installed [version] folders under a module root, ignoring non-version directories
    function Get-InstalledVersion {
        param([string]$Root)

        if (-not (Test-Path $Root)) {
            return @()
        }

        Get-ChildItem -Path $Root -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $parsed = $null
            if ([version]::TryParse((($_.Name) -replace '-.*$'), [ref]$parsed)) {
                $parsed
            }
        } | Sort-Object
    }

    $moduleRoot = Join-Path $Destination $Name

    # Version constraints shared by Find-Module and Save-Module
    $versionSplat = @{}
    if ($RequiredVersion) { $versionSplat['RequiredVersion'] = $RequiredVersion }
    if ($MinimumVersion) { $versionSplat['MinimumVersion'] = $MinimumVersion }
    if ($MaximumVersion) { $versionSplat['MaximumVersion'] = $MaximumVersion }
    $hasVersionConstraint = $versionSplat.Count -gt 0

    Write-Progress -Activity "Installing module '$Name'" -Status 'Checking installed versions' -PercentComplete 10
    Write-Verbose "Resolving installed versions of '$Name' under '$Destination'"

    $installedVersions = @(Get-InstalledVersion -Root $moduleRoot)
    $isInstalled = $installedVersions.Count -gt 0

    if ($isInstalled) {
        Write-Verbose "Found installed version(s): $($installedVersions -join ', ')"
    }
    else {
        Write-Verbose "Module '$Name' is not currently installed in the destination"
    }

    $shouldInstall = (-not $isInstalled) -or $Update -or $hasVersionConstraint

    if ($shouldInstall) {
        Write-Progress -Activity "Installing module '$Name'" -Status 'Finding module in PSGallery' -PercentComplete 40
        Write-Verbose "Querying PSGallery for '$Name'$(if ($hasVersionConstraint) { ' with version constraints' })"

        try {
            $found = Find-Module -Name $Name -Repository 'PSGallery' @versionSplat -ErrorAction Stop
        }
        catch {
            if ($isInstalled) {
                Write-Warning "Unable to query PSGallery for '$Name': $($_.Exception.Message). Keeping the installed version."
                $found = $null
            }
            else {
                Write-Progress -Activity "Installing module '$Name'" -Completed
                throw
            }
        }

        if ($found) {
            # Strip any prerelease tag so the version folder can be compared
            $targetVersion = [version]($found.Version -replace '-.*$')
            $alreadyPresent = $installedVersions -contains $targetVersion

            if ($alreadyPresent) {
                Write-Verbose "Version $($found.Version) is already present; nothing to install"
            }
            else {
                Write-Progress -Activity "Installing module '$Name'" -Status "Saving version $($found.Version)" -PercentComplete 65
                if ($PSCmdlet.ShouldProcess("$Name $($found.Version)", "Save module to '$Destination'")) {
                    Write-Verbose "Saving '$Name' version $($found.Version) to '$Destination'"
                    $found | Save-Module -Path $Destination -ErrorAction Stop
                    $installedVersions = @(Get-InstalledVersion -Root $moduleRoot)
                }
            }
        }
    }
    else {
        Write-Verbose "Module '$Name' is already installed. Use -Update to install a newer version."
    }

    if ($RemoveOtherVersions -and $installedVersions.Count -gt 1) {
        Write-Progress -Activity "Installing module '$Name'" -Status 'Removing other versions' -PercentComplete 85

        # Keep the required version when specified, otherwise the newest installed version
        $keepVersion = if ($RequiredVersion) {
            [version]($RequiredVersion -replace '-.*$')
        }
        else {
            $installedVersions | Sort-Object -Descending | Select-Object -First 1
        }

        Write-Verbose "Keeping version $keepVersion and removing all others"

        foreach ($version in $installedVersions) {
            if ($version -eq $keepVersion) {
                continue
            }

            $versionPath = Join-Path $moduleRoot $version
            if ($PSCmdlet.ShouldProcess($versionPath, 'Remove module version')) {
                Write-Verbose "Removing version $version at '$versionPath'"
                Remove-Item -Path $versionPath -Recurse -Force -ErrorAction Stop
            }
        }
    }

    Write-Progress -Activity "Installing module '$Name'" -Completed

    # Return the installed module information from the destination
    if (Test-Path $moduleRoot) {
        Get-Module -ListAvailable -Name $moduleRoot
    }
}