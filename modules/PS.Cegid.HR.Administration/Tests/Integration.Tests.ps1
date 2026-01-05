BeforeAll {
    # Import the module
    $ModulePath = Split-Path -Parent $PSScriptRoot
    $ModuleName = 'PS.Cegid.HR.Administration'
    
    if (Get-Module -Name $ModuleName) {
        Remove-Module -Name $ModuleName -Force
    }
    
    Import-Module "$ModulePath\$ModuleName.psd1" -Force
    
    # These tests require actual credentials - skip if not provided
    $script:SkipIntegration = $false
    if (-not $env:TS_BASE_URI -or -not $env:TS_CLIENT_ID -or -not $env:TS_CLIENT_SECRET) {
        $script:SkipIntegration = $true
        Write-Warning "Integration tests skipped. Set TS_BASE_URI, TS_CLIENT_ID, and TS_CLIENT_SECRET environment variables to run integration tests."
    }
}

Describe 'Integration Tests - Connect-Talentsoft' -Tag 'Integration' {
    
    BeforeAll {
        if ($script:SkipIntegration) {
            Set-ItResult -Skip -Because "Integration test credentials not provided"
        }
    }
    
    Context 'Real Connection' {
        It 'Should connect to real API successfully' -Skip:$script:SkipIntegration {
            $session = Connect-Talentsoft -BaseUri $env:TS_BASE_URI -ClientId $env:TS_CLIENT_ID -ClientSecret $env:TS_CLIENT_SECRET
            $session | Should -Not -BeNullOrEmpty
            $session.Token.access_token | Should -Not -BeNullOrEmpty
        }
        
        It 'Should fail with invalid credentials' -Skip:$script:SkipIntegration {
            { Connect-Talentsoft -BaseUri $env:TS_BASE_URI -ClientId 'invalid' -ClientSecret 'invalid' } | Should -Throw
        }
    }
}

Describe 'Integration Tests - API Calls' -Tag 'Integration' {
    
    BeforeAll {
        if ($script:SkipIntegration) {
            Set-ItResult -Skip -Because "Integration test credentials not provided"
        }
        else {
            $script:session = Connect-Talentsoft -BaseUri $env:TS_BASE_URI -ClientId $env:TS_CLIENT_ID -ClientSecret $env:TS_CLIENT_SECRET
        }
    }
    
    Context 'Test Connection' {
        It 'Should test connection successfully' -Skip:$script:SkipIntegration {
            $result = Test-TSApiConnection -tsApiSession $script:session
            $result | Should -Be $true
        }
    }
    
    Context 'Get Individuals' {
        It 'Should retrieve individuals list' -Skip:$script:SkipIntegration {
            $individuals = Get-TSIndividuals -Count 5
            $individuals | Should -Not -BeNullOrEmpty
        }
    }
    
    Context 'API Error Handling' {
        It 'Should handle 404 errors gracefully' -Skip:$script:SkipIntegration {
            { Get-TSIndividual -UserName 'nonexistent_user_12345' } | Should -Throw
        }
    }
}

AfterAll {
    Remove-Module -Name 'PS.Cegid.HR.Administration' -Force -ErrorAction SilentlyContinue
}
