function New-CustomModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [System.IO.FileSystemInfo]$Path,
        [Parameter(Mandatory=$true)]
        [string]$ModuleName,
        [Parameter(Mandatory=$true)]
        [string]$Description,
        [Parameter(Mandatory=$False)]
        [Version]$Version = "1.0.0"
    )
    
    begin {
        Write-Verbose "Starting New-CustomModule with ModuleName: $ModuleName"
        # Path shall be a directory
        if (-not (Test-Path -Path $Path.FullName -PathType Container -ErrorAction SilentlyContinue -Verbose:$false -OutVariable outVar)) {
            Write-Error "Path must be a directory"
            return
        }
        Write-Verbose "Target path validated: $($Path.FullName)"
        $dom = $env:userdomain
        $usr = $env:username
        $LoggedOnFullName = ([adsi]"WinNT://$dom/$usr,user").fullname.ToString()
        $ModulePath = Join-Path -Path $Path.FullName -ChildPath $ModuleName
        Write-Verbose "Module path set to: $ModulePath"
    }
    
    process {
        # Create Directory under $path
        Write-Verbose "Creating module directory at: $ModulePath"
        New-Item -Path $Path.FullName -Name $ModuleName -ItemType Directory | Out-Null
        # Create the PSM1 file
        Write-Verbose "Creating PSM1 file: $ModuleName.psm1"
        New-Item -Path $ModulePath -Name "$ModuleName.psm1" -ItemType File | Out-Null
        # Create Private folder
        Write-Verbose "Creating Private folder"
        New-Item -Path $ModulePath -Name "Private" -ItemType Directory | Out-Null
        # Create Public folder
        Write-Verbose "Creating Public folder"
        New-Item -Path $ModulePath -Name "Public" -ItemType Directory | Out-Null
        # Create Public folder
        Write-Verbose "Creating Tests folder"
        New-Item -Path $ModulePath -Name "Tests" -ItemType Directory | Out-Null
        New-Item -Path $ModulePath -Name "README.md" -ItemType File | Out-Null
        New-Item -Path $ModulePath -Name "CHANGELOG.md" -ItemType File | Out-Null
        # Create the Module Manifest file
        Write-Verbose "Creating module manifest: $ModuleName.psd1"
        New-ModuleManifest -Path $ModulePath\$ModuleName.psd1 -ModuleVersion $Version -Author $LoggedOnFullName -Description $Description -CompanyName "Individual" -RootModule "$ModuleName.psm1" -Copyright "(c) $LoggedOnFullName. All rights reserved." | Out-Null


        # Paste content into the PSM1 file
        Write-Verbose "Writing PSM1 content and setting up function discovery"
        $content = @'
#Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        Write-Host "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
'@
        Write-Verbose "PSM1 content created successfully"
        write-host $content
        Set-Content -Path $ModulePath\$ModuleName.psm1 -Value $content
        Write-Verbose "Module created successfully at: $ModulePath"
    }
}

$RootPath = ([String]::IsNullOrEmpty($PSScriptRoot) ? (Get-Location).Path:$PSScriptRoot)

# Check if $RootPath is a git repository
if (-not (Test-Path -Path (Join-Path -Path $RootPath -ChildPath ".git"))) {
    Write-Error "Script must be run from the root of the git repository."
    exit 1
}
$Path = Join-Path -Path $RootPath -ChildPath "modules"
# Test if it exists
if (-not (Test-Path -Path $Path)) {
    Write-Error "Modules directory not found at path: $Path"
    exit 1
}

# Collect Info from user for new module
$ModuleName = Read-Host "Enter the Module Name (e.g., PS.MyModule)"
$Description = Read-Host "Enter a brief Description of the Module"
$VersionInput = Read-Host "Enter the Module Version (default is 1.0.0)"
if ([String]::IsNullOrEmpty($VersionInput)) {
    $Version = [Version]"1.0.0"
} else {
    try {
        $Version = [Version]$VersionInput
    } catch {
        Write-Error "Invalid version format. Please use a valid version number (e.g., 1.0.0)."
        exit 1
    }
}

# Create the new module
New-CustomModule -Path (Get-Item -Path $Path) -ModuleName $ModuleName -Description $Description -Version $Version -Verbose