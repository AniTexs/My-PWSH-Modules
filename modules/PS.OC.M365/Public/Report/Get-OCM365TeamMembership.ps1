function Get-OCM365TeamMembership {
    <#
    .SYNOPSIS
        Retrieves all Microsoft Teams and their memberships.

    .DESCRIPTION
        Gets all Teams in the tenant and retrieves detailed membership information for each team.
        Returns team information along with member details including user ID, email, and roles.

    .EXAMPLE
        Get-OCM365TeamMembership
        Retrieves all teams and their members.

    .NOTES
        Requires Microsoft Graph PowerShell module and an active Graph connection.
        Required Graph API permissions: Team.ReadBasic.All, TeamMember.Read.All
    #>
    [CmdletBinding()]
    param ()

    begin {
        Write-Debug "[Get-OCM365TeamMembership] Starting function"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365TeamMembership] Successfully validated Graph connection"

        # Check required permissions using the permission hierarchy function
        $requiredScopes = @('Team.ReadBasic.All', 'TeamMember.Read.All')
        if (-not (Test-OCM365GraphPermission -RequiredPermissions $requiredScopes -Scopes $mgContext.Scopes)) {
            $message = "Missing required permissions: $($requiredScopes -join ', '). Current scopes: $($mgContext.Scopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Debug "[Get-OCM365TeamMembership] Permission validation successful"
        
        Write-Information "Starting Teams and membership retrieval" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving all Teams and their memberships..." -Verbose:$VerbosePreference
        Write-Debug "[Get-OCM365TeamMembership] Calling Get-MgTeam"
        
        try {
            $teams = Get-MgTeam -All -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference
            Write-Information "Found $($teams.Count) teams" -InformationAction $InformationPreference
            Write-Verbose "Found $($teams.Count) teams" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365TeamMembership] Retrieved teams count: $($teams.Count)"
            
            $results = foreach ($team in $teams) {
                Write-Progress -Activity "Processing Teams" -Status "Processing $($team.DisplayName)" -ProgressAction $ProgressPreference
                Write-Debug "[Get-OCM365TeamMembership] Processing team: $($team.DisplayName) (ID: $($team.Id))"
                
                Write-Verbose "Getting members for team: $($team.DisplayName)" -Verbose:$VerbosePreference
                $members = Get-MgTeamMember -TeamId $team.Id -All -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference | ForEach-Object {
                    Write-Debug "[Get-OCM365TeamMembership] Processing member: $($_.AdditionalProperties.email)"
                    @{
                        UserId       = $_.AdditionalProperties.userId
                        TenantId     = $_.AdditionalProperties.tenantId
                        Mail         = $_.AdditionalProperties.email
                        MembershipId = $_.Id
                        Roles        = $_.Roles
                    }
                }
                
                Write-Debug "[Get-OCM365TeamMembership] Team $($team.DisplayName) has $($members.Count) members"
                
                [PSCustomObject]@{
                    DisplayName = $team.DisplayName
                    TeamId      = $team.Id
                    Team        = $team
                    Members     = $members
                }
            }
            
            Write-Progress -Activity "Processing Teams" -Completed -ProgressAction $ProgressPreference
            Write-Information "Retrieved $($results.Count) teams with membership information" -InformationAction $InformationPreference
            Write-Verbose "Retrieved $($results.Count) teams with membership information" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365TeamMembership] Teams retrieval complete"
            
            return $results
        }
        catch {
            Write-Error "Failed to retrieve team memberships: $_" -ErrorAction Stop
            throw
        }
    }
}
