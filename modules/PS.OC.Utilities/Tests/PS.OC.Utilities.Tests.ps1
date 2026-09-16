$here = Split-Path -Parent $PSCommandPath
$moduleRoot = Join-Path $here '..'
Import-Module (Join-Path $moduleRoot 'PS.OC.Utilities.psd1') -Force

# Ensure the ADComputer type exists so AD parameter sets can be exercised in isolation.
Add-Type @"
namespace Microsoft.ActiveDirectory.Management {
    public class ADComputer {
        public string SamAccountName { get; set; }
        public string OperatingSystem { get; set; }
    }
}
"@ -ErrorAction SilentlyContinue

InModuleScope 'PS.OC.Utilities' {
    Describe 'Get-MSProductEndOfLifeDate' {
        BeforeAll {
            # Mock Get-ADComputer at the module scope since it may not be available
            # This ensures the mock is available even when ActiveDirectory module is not installed
            function Get-ADComputer { }
        }
    
        It 'returns a warning and no output when ADComputer is not a server' {
            $computer = [Microsoft.ActiveDirectory.Management.ADComputer]::new()
            $computer.SamAccountName = 'SRV01'
            $computer.OperatingSystem = 'Windows 10 Enterprise'

            Mock Get-ADComputer { param($Identity, $Properties) $computer }
            Mock Invoke-WebRequest { throw 'network should not be called' }
        
            $result = Get-MSProductEndOfLifeDate -Computer $computer -WarningVariable warn -WarningAction Continue

            $result | Should -BeNullOrEmpty
            $warn.Message | Should -Contain 'Computer SRV01 is not a server'
            Should -Invoke Invoke-WebRequest -Times 0
        }

        It 'builds the URL from ADComputer OS details and returns parsed JSON content' {
            $computer = [Microsoft.ActiveDirectory.Management.ADComputer]::new()
            $computer.SamAccountName = 'SRV02'
            $computer.OperatingSystem = 'Windows Server 2016 Standard'

            Mock Get-ADComputer { param($Identity, $Properties) $computer }
            Mock Invoke-WebRequest {
                [pscustomobject]@{ content = '{"cycle":"2016","eol":"2027-01-01"}' }
            }

            $result = Get-MSProductEndOfLifeDate -Computer $computer

            $result.cycle | Should -Be '2016'
            $result.eol   | Should -Be '2027-01-01'
            Should -Invoke Invoke-WebRequest -Times 1 -ParameterFilter { $Uri -eq 'https://endoflife.date/api/Windows-Server/2016.json' }
        }
    }

    Describe 'Convert-GitLog' {
        BeforeAll {
            # Define Parse-GitBlock as a dummy function so it can be mocked
            # This is a private function that may not be available in test scope
            function Parse-GitBlock { param($Text) }
        }
    
        BeforeEach {
            $script:gitBlocks = @()
            Mock Parse-GitBlock {
                param($Text)
                $script:gitBlocks += $Text.TrimEnd()
                [pscustomobject]@{ Block = $Text.TrimEnd() }
            }
        }

        It 'splits multiple commit blocks and processes each with Parse-GitBlock' {
            $lines = @(
                "commit $([string]::new('a',40))",
                'Author: user <a@b>',
                '',
                '    First commit',
                "commit $([string]::new('b',40))",
                'Author: user <a@b>',
                '',
                '    Second commit'
            )

            $result = $lines | Convert-GitLog

            $result | Should -HaveCount 2
            $result[0].Block | Should -Match 'First commit'
            $result[1].Block | Should -Match 'Second commit'
            Should -Invoke Parse-GitBlock -Times 2
        }

        It 'flushes the final buffer when the stream ends' {
            $lines = @(
                "commit $([string]::new('c',40))",
                'Author: user <a@b>',
                '',
                '    Tail commit'
            )

            $result = $lines | Convert-GitLog

            $result | Should -HaveCount 1
            $result[0].Block | Should -Match 'Tail commit'
            Should -Invoke Parse-GitBlock -Times 1
        }

        It 'ignores null pipeline elements' {
            $lines = @(
                "commit $([string]::new('d',40))",
                $null,
                '    Final'
            )

            $result = $lines | Convert-GitLog

            $result | Should -HaveCount 1
            Should -Invoke Parse-GitBlock -Times 1
        }
    }

    Describe 'Get-GitLog' {
        It 'returns nothing when git log yields no output' {
            Mock Invoke-Command { $null }
            Mock Convert-GitLog { param($Line) throw 'should not call' } -ModuleName 'PS.OC.Utilities'

            $result = Get-GitLog -NumberOfCommits 3

            $result | Should -BeNullOrEmpty
            Should -Invoke Convert-GitLog -Times 0 -ModuleName 'PS.OC.Utilities'
        }

        It 'invokes git log with the requested count and pipes results through Convert-GitLog' {
            $rawLog = @(
                "commit $([string]::new('e',40))",
                'Author: user <a@b>'
            )

            Mock Invoke-Command -ParameterFilter { $ScriptBlock -ne $null } { $rawLog }
            Mock Convert-GitLog { param($Line) [pscustomobject]@{ Line = $Line } } -ModuleName 'PS.OC.Utilities'

            $result = Get-GitLog -NumberOfCommits 5

            $result | Should -HaveCount $rawLog.Count
            $result[0].Line | Should -Be $rawLog[0]
            Should -Invoke Invoke-Command -Times 1 -ParameterFilter { $ScriptBlock.ToString() -match 'git log' }
            Should -Invoke Convert-GitLog -Times $rawLog.Count -ModuleName 'PS.OC.Utilities'
        }
    }

    Describe 'Complex Matching' {
        It 'Can Create new Match Groups' {
            $group = New-OCMatchGroup -Name 'Test Group'
            $group.Name | Should -Be 'Test Group'
            $group.Criteria.Count | Should -Be 0
        }
    
        It 'Can Create Match Group with Metadata' {
            $metadata = @{ Author = 'Tester'; Version = '1.0' }
            $group = New-OCMatchGroup -Name 'Test Group' -Metadata $metadata
            $group.Metadata.Author | Should -Be 'Tester'
            $group.Metadata.Version | Should -Be '1.0'
        }
    
        It 'Can Create new Match Criteria' {
            $criteria = New-OCMatchCriteria -Criteria { param($item) $item -eq 'A' }
            $criteria | Should -Not -BeNullOrEmpty
            $criteria.CriteriaScript | Should -Not -BeNullOrEmpty
        }
    
        It 'Can Add Match Criteria to Match Group using pipeline' {
            $group = New-OCMatchGroup -Name 'Test Group'
            $group = New-OCMatchCriteria -Criteria { param($item) $item -eq 'A' } -InputObject $group
            $group = New-OCMatchCriteria -Criteria { param($item) $item -eq 'B' } -InputObject $group
        
            $group.Criteria.Count | Should -Be 2
        }
    
        It 'Can Create Match Group with MatchCriteria objects' {
            $criteria1 = New-OCMatchCriteria -Criteria { param($item) $item -eq 'A' }
            $criteria2 = New-OCMatchCriteria -Criteria { param($item) $item -eq 'B' }
        
            $group = New-OCMatchGroup -Name 'Test Group' -Criteria @($criteria1, $criteria2)
            $group.Criteria.Count | Should -Be 2
        }
    
        It 'Can Find matching items using Find-OCMatch' {
            $criteria = New-OCMatchCriteria -Criteria { param($item) $item -eq 'TestValue' }
            $group = New-OCMatchGroup -Name 'Test Group' -Criteria @($criteria)
        
            $result = 'TestValue' | Find-OCMatch -MatchGroups @($group)
            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Be 'Test Group'
        
            $result = 'OtherValue' | Find-OCMatch -MatchGroups @($group)
            $result | Should -BeNullOrEmpty
        }
    
        It 'Can Pipeline Criteria into Match Group' {
            $group = New-OCMatchGroup -Name 'Test Group'
            $updatedGroup = New-OCMatchCriteria -Criteria { param($item) $item -eq 'A' } -InputObject $group
            
            $updatedGroup.Criteria.Count | Should -Be 1
        }
    }

    Describe 'Install-ModuleToDirectory' {
        BeforeAll {
            # Define stubs so PowerShellGet commands can be mocked even when the module is not loaded
            function Find-Module { param($Name, $Repository, $RequiredVersion, $MinimumVersion, $MaximumVersion) }
            function Save-Module { param([Parameter(ValueFromPipeline = $true)]$InputObject, $Path) }
        }

        BeforeEach {
            $script:dest = Join-Path $TestDrive 'Modules'
            if (Test-Path $script:dest) {
                Remove-Item -Path $script:dest -Recurse -Force
            }
            New-Item -ItemType Directory -Path $script:dest -Force | Out-Null

            # The function returns Get-Module output; stub it so tests stay filesystem-independent
            Mock Get-Module { } -ModuleName 'PS.OC.Utilities'
        }

        It 'installs the latest version when the module is not present' {
            Mock Find-Module { [pscustomobject]@{ Name = 'Pester'; Version = '5.5.0' } } -ModuleName 'PS.OC.Utilities'
            Mock Save-Module {
                param($Path)
                New-Item -ItemType Directory -Path (Join-Path $Path 'Pester\5.5.0') -Force | Out-Null
            } -ModuleName 'PS.OC.Utilities'

            Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest

            Should -Invoke Save-Module -Times 1 -ModuleName 'PS.OC.Utilities'
        }

        It 'does not reinstall when the found version is already present' {
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.5.0') -Force | Out-Null
            Mock Find-Module { [pscustomobject]@{ Name = 'Pester'; Version = '5.5.0' } } -ModuleName 'PS.OC.Utilities'
            Mock Save-Module { } -ModuleName 'PS.OC.Utilities'

            Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest -Update

            Should -Invoke Save-Module -Times 0 -Exactly -ModuleName 'PS.OC.Utilities'
        }

        It 'skips the PSGallery lookup when installed and neither -Update nor a version is supplied' {
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.5.0') -Force | Out-Null
            Mock Find-Module { throw 'Find-Module should not be called' } -ModuleName 'PS.OC.Utilities'
            Mock Save-Module { } -ModuleName 'PS.OC.Utilities'

            Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest

            Should -Invoke Find-Module -Times 0 -Exactly -ModuleName 'PS.OC.Utilities'
            Should -Invoke Save-Module -Times 0 -Exactly -ModuleName 'PS.OC.Utilities'
        }

        It 'installs a newer version when -Update is supplied' {
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.4.0') -Force | Out-Null
            Mock Find-Module { [pscustomobject]@{ Name = 'Pester'; Version = '5.5.0' } } -ModuleName 'PS.OC.Utilities'
            Mock Save-Module {
                param($Path)
                New-Item -ItemType Directory -Path (Join-Path $Path 'Pester\5.5.0') -Force | Out-Null
            } -ModuleName 'PS.OC.Utilities'

            Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest -Update

            Should -Invoke Save-Module -Times 1 -ModuleName 'PS.OC.Utilities'
        }

        It 'removes older versions with -RemoveOtherVersions' {
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.4.0') -Force | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.5.0') -Force | Out-Null
            Mock Find-Module { throw 'Find-Module should not be called' } -ModuleName 'PS.OC.Utilities'

            Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest -RemoveOtherVersions

            Test-Path (Join-Path $script:dest 'Pester\5.4.0') | Should -BeFalse
            Test-Path (Join-Path $script:dest 'Pester\5.5.0') | Should -BeTrue
        }

        It 'keeps all versions when -RemoveOtherVersions is combined with -WhatIf' {
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.4.0') -Force | Out-Null
            New-Item -ItemType Directory -Path (Join-Path $script:dest 'Pester\5.5.0') -Force | Out-Null

            Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest -RemoveOtherVersions -WhatIf

            Test-Path (Join-Path $script:dest 'Pester\5.4.0') | Should -BeTrue
            Test-Path (Join-Path $script:dest 'Pester\5.5.0') | Should -BeTrue
        }

        It 'rejects RequiredVersion combined with MinimumVersion' {
            { Install-ModuleToDirectory -Name 'Pester' -Destination $script:dest -RequiredVersion '5.5.0' -MinimumVersion '5.0.0' } |
                Should -Throw
        }
    }

}
