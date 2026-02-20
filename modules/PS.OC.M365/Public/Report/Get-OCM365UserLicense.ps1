function Get-OCM365UserLicense {
    <#
    .SYNOPSIS
        Retrieves license assignments for all users with licenses.

    .DESCRIPTION
        Gets all users who have licenses assigned and returns their license information.
        Returns user information along with their assigned licenses in a user-centric view.
        Optionally includes friendly names for licenses using the Get-OCM365MicrosoftLicenses function.

    .PARAMETER IncludeFriendlyNames
        If specified, includes friendly license names from the Microsoft licensing reference data.
        Otherwise, only the SkuPartNumber is used.

    .EXAMPLE
        Get-OCM365UserLicense
        Retrieves all users and their license assignments.

    .EXAMPLE
        Get-OCM365UserLicense -IncludeFriendlyNames
        Retrieves all users and their licenses with friendly names.

    .NOTES
        Requires Microsoft Graph PowerShell module and an active Graph connection.
        Required Graph API permissions: Organization.Read.All, User.Read.All
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [switch]$IncludeFriendlyNames
    )

    begin {
        Write-Debug "[Get-OCM365UserLicense] Starting function with IncludeFriendlyNames: $IncludeFriendlyNames"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365UserLicense] Successfully validated Graph connection"

        # Check required permissions using the permission hierarchy function
        $requiredScopes = @('Organization.Read.All', 'User.Read.All')
        if (-not (Test-OCM365GraphPermission -RequiredPermissions $requiredScopes -Scopes $mgContext.Scopes)) {
            $message = "Missing required permissions: $($requiredScopes -join ', '). Current scopes: $($mgContext.Scopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Debug "[Get-OCM365UserLicense] Permission validation successful"

        # Prepare friendly names lookup if requested
        $friendlyNamesLookup = @{}
        if ($IncludeFriendlyNames) {
            Write-Debug "[Get-OCM365UserLicense] Retrieving friendly names from Microsoft licensing reference"
            try {
                $allLicenses = Get-OCM365MicrosoftLicenses -ErrorAction Stop
                $friendlyNamesLookup = @{}
                foreach ($license in $allLicenses) {
                    $friendlyNamesLookup[$license.SkuId] = $license.DisplayName
                }
                Write-Debug "[Get-OCM365UserLicense] Loaded $($friendlyNamesLookup.Count) friendly license names"
            }
            catch {
                Write-Warning "Failed to retrieve friendly license names: $_"
                Write-Debug "[Get-OCM365UserLicense] Continuing with SkuPartNumber only"
            }
        }
        
        Write-Information "Starting user license retrieval" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving all licenses and user mappings..." -Verbose:$VerbosePreference
        
        try {
            Write-Debug "[Get-OCM365UserLicense] Calling Get-MgSubscribedSku"
            
            # Get all licenses with their assignments
            $Licenses = Get-MgSubscribedSku -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference | ForEach-Object {
                Write-Progress -Activity "Processing Licenses" -Status "Processing $($_.SkuPartNumber)" -ProgressAction $ProgressPreference
                Write-Debug "[Get-OCM365UserLicense] Processing license: $($_.SkuPartNumber)"
                
                # Get friendly name if available
                $friendlyName = $_.SkuPartNumber
                if ($IncludeFriendlyNames -and $friendlyNamesLookup.ContainsKey($_.SkuId)) {
                    $friendlyName = $friendlyNamesLookup[$_.SkuId]
                    Write-Debug "[Get-OCM365UserLicense] Got friendly name: $friendlyName"
                }
                
                # Get assigned users
                Write-Debug "[Get-OCM365UserLicense] Getting assigned users for SKU: $($_.SkuId)"
                $assignedUsers = Get-MgUser -Filter "assignedLicenses/any(u:u/skuId eq $($_.SkuId))" -All -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference
                
                [PSCustomObject]@{
                    SkuId         = $_.SkuId
                    SkuPartNumber = $_.SkuPartNumber
                    FriendlyName  = $friendlyName
                    AssignedUsers = $assignedUsers
                }
            }
            
            Write-Progress -Activity "Processing Licenses" -Completed -ProgressAction $ProgressPreference
            Write-Verbose "Retrieved $($Licenses.Count) licenses" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365UserLicense] License retrieval complete"
            
            # Get unique users
            Write-Verbose "Getting unique assigned users and building user-license mapping..." -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365UserLicense] Extracting unique users from licenses"
            
            $Users = $Licenses | 
                Select-Object -ExpandProperty AssignedUsers | 
                Sort-Object -Property Id -Unique
            
            Write-Information "Found $($Users.Count) unique users with licenses" -InformationAction $InformationPreference
            Write-Verbose "Found $($Users.Count) unique users with licenses" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365UserLicense] User extraction complete"
            
            # Create user-centric output
            Write-Debug "[Get-OCM365UserLicense] Building user-centric license mapping"
            
            $results = foreach ($user in $Users) {
                Write-Progress -Activity "Processing Users" -Status "Processing $($user.UserPrincipalName)" -ProgressAction $ProgressPreference
                Write-Debug "[Get-OCM365UserLicense] Processing user: $($user.UserPrincipalName)"
                
                $assignedLicenses = $Licenses | 
                    Where-Object { $_.AssignedUsers.Id -contains $user.Id } | 
                    Select-Object SkuId, SkuPartNumber, FriendlyName
                
                [PSCustomObject]@{
                    UserPrincipalName = $user.UserPrincipalName
                    DisplayName       = $user.DisplayName
                    Mail              = $user.Mail
                    AssignedLicenses  = $assignedLicenses
                }
            }
            
            Write-Progress -Activity "Processing Users" -Completed -ProgressAction $ProgressPreference
            Write-Information "Processed $($results.Count) users with license information" -InformationAction $InformationPreference
            Write-Verbose "Processed $($results.Count) users with license information" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365UserLicense] User processing complete"
            
            return $results
        }
        catch {
            Write-Error "Failed to retrieve user license information: $_" -ErrorAction Stop
            throw
        }
    }
}
