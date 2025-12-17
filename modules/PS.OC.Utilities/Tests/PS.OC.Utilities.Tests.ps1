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
    It 'returns a warning and no output when ADComputer is not a server' {
        $computer = [Microsoft.ActiveDirectory.Management.ADComputer]::new()
        $computer.SamAccountName = 'SRV01'
        $computer.OperatingSystem = 'Windows 10 Enterprise'

        Mock Get-ADComputer { param($Identity, $Properties) $Identity }
        Mock Invoke-WebRequest { throw 'network should not be called' }
        
        $result = Get-MSProductEndOfLifeDate -Computer $computer -WarningVariable warn -WarningAction Continue

        $result | Should -BeNullOrEmpty
        $warn | Should -Contain 'Computer SRV01 is not a server'
        Assert-MockCalled Invoke-WebRequest -Times 0
    }

    It 'builds the URL from ADComputer OS details and returns parsed JSON content' {
        $computer = [Microsoft.ActiveDirectory.Management.ADComputer]::new()
        $computer.SamAccountName = 'SRV02'
        $computer.OperatingSystem = 'Windows Server 2016 Standard'

        Mock Get-ADComputer { param($Identity, $Properties) $Identity }
        Mock Invoke-WebRequest {
            [pscustomobject]@{ content = '{"cycle":"2016","eol":"2027-01-01"}' }
        }

        $result = Get-MSProductEndOfLifeDate -Computer $computer

        $result.cycle | Should -Be '2016'
        $result.eol   | Should -Be '2027-01-01'
        Assert-MockCalled Invoke-WebRequest -Times 1 -ParameterFilter { $Uri -eq 'https://endoflife.date/api/Windows-Server/2016.json' }
    }
}

Describe 'Convert-GitLog' {
    BeforeEach {
        $script:gitBlocks = @()
        Mock Parse-GitBlock {
            param($block)
            $script:gitBlocks += $block.TrimEnd()
            [pscustomobject]@{ Block = $block.TrimEnd() }
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
        Assert-MockCalled Parse-GitBlock -Times 2
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
        Assert-MockCalled Parse-GitBlock -Times 1
    }

    It 'ignores null pipeline elements' {
        $lines = @(
            "commit $([string]::new('d',40))",
            $null,
            '    Final'
        )

        $result = $lines | Convert-GitLog

        $result | Should -HaveCount 1
        Assert-MockCalled Parse-GitBlock -Times 1
    }
}

Describe 'Get-GitLog' {
    It 'returns nothing when git log yields no output' {
        Mock Invoke-Command { $null }
        Mock Convert-GitLog { param($Line) throw 'should not call' }

        $result = Get-GitLog -NumberOfCommits 3

        $result | Should -BeNullOrEmpty
        Assert-MockCalled Convert-GitLog -Times 0
    }

    It 'invokes git log with the requested count and pipes results through Convert-GitLog' {
        $rawLog = @(
            "commit $([string]::new('e',40))",
            'Author: user <a@b>'
        )

        Mock Invoke-Command -ParameterFilter { $ScriptBlock -ne $null } { $rawLog }
        Mock Convert-GitLog { param($Line) [pscustomobject]@{ Line = $Line } }

        $result = Get-GitLog -NumberOfCommits 5

        $result | Should -HaveCount $rawLog.Count
        $result[0].Line | Should -Be $rawLog[0]
        Assert-MockCalled Invoke-Command -Times 1 -ParameterFilter { $ScriptBlock.ToString() -match 'git log -n 5' }
        Assert-MockCalled Convert-GitLog -Times $rawLog.Count
    }
}

}
