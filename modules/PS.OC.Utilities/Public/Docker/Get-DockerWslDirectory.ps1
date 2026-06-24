function Get-DockerWslDirectory {
    [CmdletBinding()]
    param ()

    $lxssPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss'

    if (-not (Test-Path $lxssPath)) {
        throw "WSL registry path was not found: $lxssPath"
    }

    $dockerDistros = Get-ChildItem $lxssPath |
        ForEach-Object {
            Get-ItemProperty $_.PSPath |
                Select-Object DistributionName, BasePath
        } |
        Where-Object {
            $_.DistributionName -like '*docker*' -and
            -not [string]::IsNullOrWhiteSpace($_.BasePath)
        }

    foreach ($distro in $dockerDistros) {
        # Correctly remove \\?\ prefix
        $basePath = $distro.BasePath -replace '^\\\\\?\\', ''
        $basePath = $basePath.Trim()

        # Example:
        # C:\Users\dkneja\AppData\Local\Docker\wsl\main
        # becomes:
        # C:\Users\dkneja\AppData\Local\Docker\wsl
        $dockerWslRoot = Split-Path -Path $basePath -Parent

        if (-not (Test-Path $dockerWslRoot)) {
            continue
        }

        Get-ChildItem -Path $dockerWslRoot -Filter '*.vhdx' -Recurse -File -ErrorAction SilentlyContinue |
            ForEach-Object {
                [pscustomobject]@{
                    DistributionName = $distro.DistributionName
                    BasePath         = $basePath
                    DockerWslRoot    = $dockerWslRoot
                    Directory        = $_.DirectoryName
                    VhdxName         = $_.Name
                    VhdxPath         = $_.FullName
                    SizeGB           = [math]::Round($_.Length / 1GB, 2)
                }
            }
    }
}

function Invoke-DockerWslDiskCleanup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        # Runs docker system prune.
        [switch] $Prune,

        # Adds -a to docker system prune.
        # This removes all unused images, not only dangling images.
        [switch] $AllImages,

        # Adds --volumes to docker system prune.
        # Dangerous if you have unused Docker volumes containing data.
        [switch] $Volumes,

        # Compacts Docker Desktop WSL VHDX files.
        [switch] $Compact,

        # Try Optimize-VHD first, otherwise DiskPart.
        [ValidateSet('Auto', 'OptimizeVHD', 'DiskPart')]
        [string] $CompactionMethod = 'Auto',

        # Try to close Docker Desktop processes before WSL shutdown.
        [switch] $StopDockerDesktop
    )

    function Test-IsAdministrator {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal]::new($identity)

        return $principal.IsInRole(
            [Security.Principal.WindowsBuiltInRole]::Administrator
        )
    }

    function Invoke-DiskPartVhdxCompact {
        param (
            [Parameter(Mandatory)]
            [string] $Path
        )

        $diskPartScript = @"
select vdisk file="$Path"
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@

        $tempFile = New-TemporaryFile

        try {
            Set-Content -Path $tempFile.FullName -Value $diskPartScript -Encoding ASCII

            $output = & diskpart.exe /s $tempFile.FullName 2>&1

            if ($LASTEXITCODE -ne 0) {
                throw "DiskPart failed for '$Path'. Output: $($output -join [Environment]::NewLine)"
            }

            $output
        }
        finally {
            Remove-Item $tempFile.FullName -Force -ErrorAction SilentlyContinue
        }
    }

    function Get-FileSizeGB {
        param (
            [Parameter(Mandatory)]
            [string] $Path
        )

        if (-not (Test-Path $Path)) {
            return $null
        }

        $item = Get-Item $Path
        [math]::Round($item.Length / 1GB, 2)
    }

    if ($Prune) {
        $dockerArgs = @('system', 'prune', '-f')

        if ($AllImages) {
            $dockerArgs += '-a'
        }

        if ($Volumes) {
            $dockerArgs += '--volumes'
        }

        $commandText = "docker $($dockerArgs -join ' ')"

        if ($PSCmdlet.ShouldProcess('Docker', $commandText)) {
            & docker @dockerArgs

            if ($LASTEXITCODE -ne 0) {
                throw "Docker prune failed. Command was: $commandText"
            }
        }
    }

    if ($Compact) {
        if (-not (Test-IsAdministrator)) {
            throw "Compacting VHDX files requires PowerShell to be running as Administrator."
        }

        $vhdxFiles = Get-DockerWslDirectory

        if (-not $vhdxFiles) {
            throw "No Docker Desktop WSL ext4.vhdx files were found."
        }

        if ($StopDockerDesktop) {
            $processNames = @(
                'Docker Desktop'
                'com.docker.backend'
                'com.docker.build'
                'com.docker.dev-envs'
            )

            foreach ($name in $processNames) {
                Get-Process -Name $name -ErrorAction SilentlyContinue |
                    Stop-Process -Force -ErrorAction SilentlyContinue
            }
        }

        if ($PSCmdlet.ShouldProcess('WSL', 'wsl --shutdown')) {
            & wsl.exe --shutdown

            if ($LASTEXITCODE -ne 0) {
                throw "wsl --shutdown failed."
            }

            Start-Sleep -Seconds 2
        }

        $optimizeVhdAvailable = [bool](Get-Command Optimize-VHD -ErrorAction SilentlyContinue)

        foreach ($vhdx in $vhdxFiles) {
            $method = switch ($CompactionMethod) {
                'OptimizeVHD' { 'OptimizeVHD' }
                'DiskPart'    { 'DiskPart' }
                'Auto' {
                    if ($optimizeVhdAvailable) {
                        'OptimizeVHD'
                    }
                    else {
                        'DiskPart'
                    }
                }
            }

            $beforeGB = Get-FileSizeGB -Path $vhdx.VhdxPath

            if ($PSCmdlet.ShouldProcess($vhdx.VhdxPath, "Compact using $method")) {
                if ($method -eq 'OptimizeVHD') {
                    Optimize-VHD -Path $vhdx.VhdxPath -Mode Full
                }
                else {
                    Invoke-DiskPartVhdxCompact -Path $vhdx.VhdxPath | Out-Host
                }
            }

            $afterGB = Get-FileSizeGB -Path $vhdx.VhdxPath

            [pscustomobject]@{
                DistributionName = $vhdx.DistributionName
                VhdxPath         = $vhdx.VhdxPath
                Method           = $method
                BeforeGB         = $beforeGB
                AfterGB          = $afterGB
                SavedGB          = if ($beforeGB -ne $null -and $afterGB -ne $null) {
                    [math]::Round($beforeGB - $afterGB, 2)
                }
                else {
                    $null
                }
            }
        }
    }
}