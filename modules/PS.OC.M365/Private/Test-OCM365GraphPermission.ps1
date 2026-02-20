function Test-OCM365GraphPermission {
    <#
    .SYNOPSIS
        Tests if the current Microsoft Graph connection has required permissions.

    .DESCRIPTION
        Validates that the current Microsoft Graph connection has the required permissions.
        Understands permission hierarchies:
        - Super-permissions like Directory.ReadWrite.All cover multiple specific permissions
        - ReadWrite permissions satisfy Read requirements
        - Maintains a permission hierarchy map for accurate validation

    .PARAMETER RequiredPermissions
        Array of required Microsoft Graph permissions to check for.

    .PARAMETER Scopes
        Array of current permission scopes from the Graph connection.
        If not provided, retrieves from current MgContext.

    .PARAMETER Details
        If specified, returns detailed object with permission analysis instead of boolean.
        The returned object includes:
        - RequiredPermissions: The permissions that were checked
        - GrantedPermissions: The permissions currently available
        - MissingPermissions: Any permissions that were not satisfied
        - HasAccess: Boolean indicating if all required permissions are available
        - Notes: Additional details about the permission check

    .EXAMPLE
        Test-OCM365GraphPermission -RequiredPermissions @('Application.Read.All', 'Directory.Read.All')
        Returns $true or $false.

    .EXAMPLE
        @('User.Read.All', 'Organization.Read.All') | Test-OCM365GraphPermission
        Returns $true or $false via pipeline.

    .EXAMPLE
        Test-OCM365GraphPermission -RequiredPermissions @('User.Read.All') -Scopes $mgContext.Scopes -Details
        Returns detailed object with permission analysis.

    .OUTPUTS
        System.Boolean
        Returns $true if all required permissions are satisfied, $false otherwise.
        
        When -Details is specified:
        PSCustomObject with properties: Item, ItemType, RequiredPermissions, GrantedPermissions, MissingPermissions, HasAccess, Notes

    .NOTES
        This function understands permission hierarchies:
        - Directory.ReadWrite.All covers Application.*, Directory.*, User.*, and Organization.Read.All
        - Organization.ReadWrite.All covers Organization.Read.All
        - ReadWrite.All covers Read.All of the same resource
        - TeamSettings.ReadWrite.All covers Team operations
        - Group permissions cover Team operations (Teams are built on Groups)
        - TeamMember.ReadWrite.All covers TeamMember.Read.All
        - All patterns are case-insensitive
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$RequiredPermissions,

        [Parameter()]
        [string[]]$Scopes,
        
        [Parameter()]
        [switch]$Details
    )

    begin {
        Write-Debug "[Test-OCM365GraphPermission] Starting permission check"
        
        # Define permission hierarchy - super permissions that satisfy lower permissions
        $permissionHierarchy = @{
            # Directory.ReadWrite.All is a super-permission covering Application and Directory operations
            'Directory.ReadWrite.All' = @(
                'Application.Read.All',
                'Application.ReadWrite.All',
                'Application.ReadWrite.OwnedBy',
                'Directory.Read.All',
                'Directory.ReadWrite.All',
                'Organization.Read.All',
                'Organization.ReadWrite.All',
                'User.Read.All',
                'User.ReadWrite.All'
            )
            # Directory.Read.All covers read operations on applications and directory
            'Directory.Read.All' = @(
                'Application.Read.All',
                'Directory.Read.All',
                'Organization.Read.All'
            )
            # Organization.ReadWrite.All covers Organization operations
            'Organization.ReadWrite.All' = @(
                'Organization.Read.All',
                'Organization.ReadWrite.All'
            )
            # ReadWrite covers Read of the same resource
            'Application.ReadWrite.All' = @(
                'Application.Read.All',
                'Application.ReadWrite.All'
            )
            'User.ReadWrite.All' = @(
                'User.Read.All',
                'User.ReadWrite.All'
            )
            # TeamSettings permissions cover Team operations
            'TeamSettings.ReadWrite.All' = @(
                'Team.ReadBasic.All',
                'TeamSettings.Read.All',
                'TeamSettings.ReadWrite.All'
            )
            'TeamSettings.Read.All' = @(
                'Team.ReadBasic.All',
                'TeamSettings.Read.All'
            )
            # Group permissions cover Team operations (Teams are built on Groups)
            'Group.ReadWrite.All' = @(
                'Team.ReadBasic.All',
                'Group.Read.All',
                'Group.ReadWrite.All',
                'TeamSettings.Read.All',
                'TeamSettings.ReadWrite.All'
            )
            'Group.Read.All' = @(
                'Team.ReadBasic.All',
                'Group.Read.All'
            )
            # TeamMember permissions
            'TeamMember.ReadWrite.All' = @(
                'TeamMember.Read.All',
                'TeamMember.ReadWrite.All'
            )
        }
        
        if (-not $Scopes) {
            $mgContext = Get-MgContext
            if ($mgContext) {
                $Scopes = $mgContext.Scopes
            }
        }

        if (-not $Scopes) {
            Write-Debug "[Test-OCM365GraphPermission] No scopes available"
            $Scopes = @()
        }

        Write-Debug "[Test-OCM365GraphPermission] Available scopes: $($Scopes -join ', ')"
    }

    process {
        Write-Debug "[Test-OCM365GraphPermission] Required permissions: $($RequiredPermissions -join ', ')"
        
        $missingPermissions = @()
        $allPermissionsSatisfied = $true

        foreach ($requiredPermission in $RequiredPermissions) {
            $scopeFound = $false
            Write-Debug "[Test-OCM365GraphPermission] Checking permission: $requiredPermission"
            
            # Check 1: Exact permission match
            if ($requiredPermission -in $Scopes) {
                Write-Debug "[Test-OCM365GraphPermission] Found exact match: $requiredPermission"
                $scopeFound = $true
            }
            
            # Check 2: Permission hierarchy - does a super-permission cover this requirement?
            if (-not $scopeFound) {
                foreach ($currentScope in $Scopes) {
                    if ($currentScope -in $permissionHierarchy.Keys) {
                        if ($requiredPermission -in $permissionHierarchy[$currentScope]) {
                            Write-Debug "[Test-OCM365GraphPermission] Found hierarchical permission: $currentScope satisfies $requiredPermission"
                            $scopeFound = $true
                            break
                        }
                    }
                }
            }
            
            # Check 3: ReadWrite/Read upgrade pattern
            if (-not $scopeFound -and $requiredPermission -like '*.Read.All') {
                $upgradeScope = $requiredPermission -replace '\.Read\.All', '.ReadWrite.All'
                if ($upgradeScope -in $Scopes) {
                    Write-Debug "[Test-OCM365GraphPermission] Found upgraded permission: $upgradeScope satisfies $requiredPermission"
                    $scopeFound = $true
                }
            }
            
            # Track missing permissions
            if (-not $scopeFound) {
                Write-Debug "[Test-OCM365GraphPermission] Permission not satisfied: $requiredPermission"
                $missingPermissions += $requiredPermission
                $allPermissionsSatisfied = $false
            }
        }

        # Build result object
        $resultObject = [pscustomobject]@{
            Item                 = "Permission Check"
            ItemType             = "GraphPermission"
            RequiredPermissions  = $RequiredPermissions
            GrantedPermissions   = $Scopes
            MissingPermissions   = $missingPermissions
            HasAccess            = $allPermissionsSatisfied
            Notes                = if ($missingPermissions) {
                "Missing required permissions: $($missingPermissions -join ', ')"
            } else {
                $null
            }
        }

        if ($Details) {
            Write-Debug "[Test-OCM365GraphPermission] Returning detailed object"
            $resultObject
        } else {
            Write-Debug "[Test-OCM365GraphPermission] Returning: $allPermissionsSatisfied"
            $allPermissionsSatisfied
        }
    }
}
