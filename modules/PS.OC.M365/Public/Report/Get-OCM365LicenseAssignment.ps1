function Get-OCM365LicenseAssignment {
    <#
    .SYNOPSIS
        Retrieves all Microsoft 365 licenses and their user assignments.

    .DESCRIPTION
        Gets all subscribed SKUs from the tenant and retrieves all users assigned to each license.
        Optionally includes friendly names for licenses using the Get-OCM365MicrosoftLicenses function.

    .PARAMETER IncludeFriendlyNames
        If specified, includes friendly license names from the Microsoft licensing reference data.
        Otherwise, only the SkuPartNumber is used.

    .EXAMPLE
        Get-OCM365LicenseAssignment
        Retrieves all licenses and their assignments.

    .EXAMPLE
        Get-OCM365LicenseAssignment -IncludeFriendlyNames

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
        Write-Debug "[Get-OCM365LicenseAssignment] Starting function with IncludeFriendlyNames: $IncludeFriendlyNames"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365LicenseAssignment] Successfully validated Graph connection"

        # Check required permissions using the permission hierarchy function
        $requiredScopes = @('Organization.Read.All', 'User.Read.All')
        if (-not (Test-OCM365GraphPermission -RequiredPermissions $requiredScopes -Scopes $mgContext.Scopes)) {
            $message = "Missing required permissions: $($requiredScopes -join ', '). Current scopes: $($mgContext.Scopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Debug "[Get-OCM365LicenseAssignment] Permission validation successful"

        # Prepare friendly names lookup if requested
        $friendlyNamesLookup = @{}
        if ($IncludeFriendlyNames) {
            Write-Debug "[Get-OCM365LicenseAssignment] Retrieving friendly names from Microsoft licensing reference"
            try {
                $allLicenses = Get-OCM365MicrosoftLicenses -ErrorAction Stop
                $friendlyNamesLookup = @{}
                foreach ($license in $allLicenses) {
                    $friendlyNamesLookup[$license.SkuId] = $license.DisplayName
                }
                Write-Debug "[Get-OCM365LicenseAssignment] Loaded $($friendlyNamesLookup.Count) friendly license names"
            }
            catch {
                Write-Warning "Failed to retrieve friendly license names: $_"
                Write-Debug "[Get-OCM365LicenseAssignment] Continuing with SkuPartNumber only"
            }
        }
        
        Write-Information "Starting license assignment retrieval" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving all licenses and assignments..." -Verbose:$VerbosePreference
        
        try {
            Write-Debug "[Get-OCM365LicenseAssignment] Calling Get-MgSubscribedSku"
            
            $Licenses = Get-MgSubscribedSku -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference | ForEach-Object {
                Write-Progress -Activity "Processing Licenses" -Status "Processing $($_.SkuPartNumber)" -ProgressAction $ProgressPreference
                Write-Debug "[Get-OCM365LicenseAssignment] Processing license: $($_.SkuPartNumber)"
                
                # Get friendly name if available
                $friendlyName = $_.SkuPartNumber
                if ($IncludeFriendlyNames -and $friendlyNamesLookup.ContainsKey($_.SkuId)) {
                    $friendlyName = $friendlyNamesLookup[$_.SkuId]
                    Write-Debug "[Get-OCM365LicenseAssignment] Got friendly name: $friendlyName"
                }
                
                # Get assigned users
                Write-Debug "[Get-OCM365LicenseAssignment] Getting assigned users for SKU: $($_.SkuId)"
                $assignedUsers = Get-MgUser -Filter "assignedLicenses/any(u:u/skuId eq $($_.SkuId))" -All -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference
                
                [PSCustomObject]@{
                    SkuId         = $_.SkuId
                    SkuPartNumber = $_.SkuPartNumber
                    FriendlyName  = $friendlyName
                    AssignedUsers = $assignedUsers
                }
            }
            
            Write-Progress -Activity "Processing Licenses" -Completed -ProgressAction $ProgressPreference
            Write-Information "Retrieved $($Licenses.Count) licenses with assignments" -InformationAction $InformationPreference
            Write-Verbose "Retrieved $($Licenses.Count) licenses" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365LicenseAssignment] License retrieval complete"
            
            return $Licenses
        }
        catch {
            Write-Error "Failed to retrieve license assignments: $_" -ErrorAction Stop
            throw
        }
    }
}
