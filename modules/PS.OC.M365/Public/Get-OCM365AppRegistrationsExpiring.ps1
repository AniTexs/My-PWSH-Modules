
function Get-OCM365AppRegistrationsExpiring {
    <#
    .SYNOPSIS
        Retrieves Azure AD application registrations with expiring or expired credentials.

    .DESCRIPTION
        Gets all application registrations and identifies client secrets and certificates that are expired or expiring soon.
        Includes application owner information and credential expiry details.

    .PARAMETER ClientSecretsOnly
        If specified, only displays expiring/expired client secrets (excludes certificates).

    .PARAMETER CertificatesOnly
        If specified, only displays expiring/expired certificates (excludes client secrets).

    .PARAMETER SoonToExpireInDays
        Number of days to consider credentials as "soon to expire". Default is 60 days.
        Only credentials expiring within this threshold will be returned.

    .EXAMPLE
        Get-OCM365AppRegistrationsExpiring
        Retrieves all credentials (secrets and certificates) expiring within 60 days.

    .EXAMPLE
        Get-OCM365AppRegistrationsExpiring -ClientSecretsOnly -SoonToExpireInDays 30
        Retrieves only client secrets expiring within 30 days.

    .EXAMPLE
        Get-OCM365AppRegistrationsExpiring -CertificatesOnly -SoonToExpireInDays 90
        Retrieves only certificates expiring within 90 days.

    .NOTES
        Requires Microsoft Graph PowerShell module and an active Graph connection.
        Required Graph API permissions: Application.Read.All, Directory.Read.All
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]$ClientSecretsOnly,

        [Parameter()]
        [Switch]$CertificatesOnly,

        [Parameter()]
        [int]$SoonToExpireInDays = 60
    )

    begin {
        Write-Debug "[Get-OCM365AppRegistrationsExpiring] Starting function with ClientSecretsOnly: $ClientSecretsOnly, CertificatesOnly: $CertificatesOnly, SoonToExpireInDays: $SoonToExpireInDays"
        
        # Check if connected to Microsoft Graph
        $mgContext = Get-MgContext
        if (-not $mgContext) {
            Write-Error "Not connected to Microsoft Graph. Please run Connect-MgGraph first." -ErrorAction Stop
            throw "Not connected to Microsoft Graph. Please run Connect-MgGraph first."
        }
        
        Write-Debug "[Get-OCM365AppRegistrationsExpiring] Successfully validated Graph connection"

        # Check required permissions using the permission hierarchy function
        $requiredScopes = @('Application.Read.All', 'Directory.Read.All')
        if (-not (Test-OCM365GraphPermission -RequiredPermissions $requiredScopes -Scopes $mgContext.Scopes)) {
            $message = "Missing required permissions: $($requiredScopes -join ', '). Current scopes: $($mgContext.Scopes -join ', ')"
            Write-Error $message -ErrorAction Stop
            throw $message
        }
        
        Write-Debug "[Get-OCM365AppRegistrationsExpiring] Permission validation successful"
        Write-Information "Starting application registration credential expiry scan" -InformationAction $InformationPreference
    }

    process {
        Write-Verbose "Retrieving all application registrations..." -Verbose:$VerbosePreference
        Write-Debug "[Get-OCM365AppRegistrationsExpiring] Fetching applications with properties: DisplayName, AppId, Id, KeyCredentials, PasswordCredentials, CreatedDateTime, SigninAudience"
        
        try {
            $ExportResults = @()
            $AppCount = 0
            $PrintedCount = 0
            $RequiredProperties = @('DisplayName', 'AppId', 'Id', 'KeyCredentials', 'PasswordCredentials', 'CreatedDateTime', 'SigninAudience')
            
            $Applications = Get-MgApplication -All -Property $RequiredProperties -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference
            $TotalApps = $Applications.Count
            
            Write-Information "Found $TotalApps application registrations to process" -InformationAction $InformationPreference
            Write-Verbose "Found $TotalApps applications - processing credentials..." -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365AppRegistrationsExpiring] Processing $TotalApps applications"

            foreach ($Application in $Applications) {
                $AppCount++
                $AppName = $Application.DisplayName
                $AppId = $Application.Id
                
                Write-Progress -Activity "Processing Application Registrations" `
                    -Status "Processing app $AppCount of $($TotalApps): $AppName" `
                    -PercentComplete (($AppCount / $TotalApps) * 100) `
                    -ProgressAction $ProgressPreference

                Write-Debug "[Get-OCM365AppRegistrationsExpiring] Processing application: $AppName (AppId: $($Application.AppId))"

                # Get application owners
                Write-Debug "[Get-OCM365AppRegistrationsExpiring] Retrieving owners for app: $AppId"
                $Owners = ""
                try {
                    $OwnerList = Get-MgApplicationOwner -ApplicationId $AppId -ErrorAction Stop -Verbose:$VerbosePreference -Debug:$DebugPreference
                    $Owners = ($OwnerList.AdditionalProperties.userPrincipalName) -join ", "
                }
                catch {
                    Write-Warning "Failed to retrieve owners for $AppName : $_"
                    Write-Debug "[Get-OCM365AppRegistrationsExpiring] Failed to get owners for AppId: $AppId"
                    $Owners = "-"
                }

                if ([string]::IsNullOrEmpty($Owners)) {
                    $Owners = "-"
                }

                Write-Debug "[Get-OCM365AppRegistrationsExpiring] App owners: $Owners"

                # Get secrets from the application
                $Secrets = $Application.PasswordCredentials
                $Certificates = $Application.KeyCredentials
                $AppCreationDate = $Application.CreatedDateTime
                $SigninAudience = $Application.SignInAudience

                Write-Debug "[Get-OCM365AppRegistrationsExpiring] Found $($Secrets.Count) client secrets and $($Certificates.Count) certificates"

                #region Process Client Secrets
                if (-not $CertificatesOnly.IsPresent) {
                    Write-Verbose "Processing $($Secrets.Count) client secrets for $AppName" -Verbose:$VerbosePreference
                    Write-Debug "[Get-OCM365AppRegistrationsExpiring] Processing client secrets for: $AppName"
                    
                    foreach ($Secret in $Secrets) {
                        $DisplayName = $Secret.DisplayName
                        $Id = $Secret.KeyId
                        $CreatedTime = $Secret.StartDateTime
                        $ExpiryDate = $Secret.EndDateTime
                        $DaysToExpiry = (New-TimeSpan -Start (Get-Date).Date -End $ExpiryDate).Days

                        Write-Debug "[Get-OCM365AppRegistrationsExpiring] Secret: $DisplayName, Days to expiry: $DaysToExpiry"

                        # Check if credential meets filter criteria
                        $IncludeSecret = $true

                        if ($DaysToExpiry -lt 0) {
                            Write-Verbose "Secret '$DisplayName' has EXPIRED ($DaysToExpiry days)" -Verbose:$VerbosePreference
                        }
                        else {
                            Write-Verbose "Secret '$DisplayName' expires in $DaysToExpiry days" -Verbose:$VerbosePreference
                        }

                        # Filter for soon-to-expire client secrets
                        if ($DaysToExpiry -gt $SoonToExpireInDays) {
                            $IncludeSecret = $false
                            Write-Debug "[Get-OCM365AppRegistrationsExpiring] Secret excluded (expires beyond threshold): $DisplayName"
                        }

                        if ($IncludeSecret) {
                            $PrintedCount++
                            $ExpiryStatus = if ($DaysToExpiry -lt 0) { "Expired" } else { "Active" }
                            $FriendlyExpiryTime = if ($DaysToExpiry -lt 0) { "Expired $([Math]::Abs($DaysToExpiry)) days ago" } else { "Expires in $DaysToExpiry days" }

                            $ExportResult = [PSCustomObject]@{
                                'App Name'           = $AppName
                                'App Owners'         = $Owners
                                'App Creation Time'  = $AppCreationDate
                                'Credential Type'    = "Client Secret"
                                'Name'               = $DisplayName
                                'Id'                 = $Id
                                'Creation Time'      = $CreatedTime
                                'Expiry Date'        = $ExpiryDate
                                'Days to Expiry'     = $DaysToExpiry
                                'Friendly Expiry'    = $FriendlyExpiryTime
                                'App Id'             = $Application.AppId
                                'Status'             = $ExpiryStatus
                            }
                            $ExportResults += $ExportResult
                            Write-Information "Found expiring/expired secret: $AppName - $DisplayName (Days to expiry: $DaysToExpiry)" -InformationAction $InformationPreference
                        }
                    }
                }
                #endregion

                #region Process Certificates
                if (-not $ClientSecretsOnly.IsPresent) {
                    Write-Verbose "Processing $($Certificates.Count) certificates for $AppName" -Verbose:$VerbosePreference
                    Write-Debug "[Get-OCM365AppRegistrationsExpiring] Processing certificates for: $AppName"
                    
                    foreach ($Certificate in $Certificates) {
                        $DisplayName = $Certificate.DisplayName
                        $Id = $Certificate.KeyId
                        $CreatedTime = $Certificate.StartDateTime
                        $ExpiryDate = $Certificate.EndDateTime
                        $DaysToExpiry = (New-TimeSpan -Start (Get-Date).Date -End $ExpiryDate).Days

                        Write-Debug "[Get-OCM365AppRegistrationsExpiring] Certificate: $DisplayName, Days to expiry: $DaysToExpiry"

                        # Check if credential meets filter criteria
                        $IncludeCert = $true

                        if ($DaysToExpiry -lt 0) {
                            Write-Verbose "Certificate '$DisplayName' has EXPIRED ($DaysToExpiry days)" -Verbose:$VerbosePreference
                        }
                        else {
                            Write-Verbose "Certificate '$DisplayName' expires in $DaysToExpiry days" -Verbose:$VerbosePreference
                        }

                        # Filter for soon-to-expire certificates
                        if ($DaysToExpiry -gt $SoonToExpireInDays) {
                            $IncludeCert = $false
                            Write-Debug "[Get-OCM365AppRegistrationsExpiring] Certificate excluded (expires beyond threshold): $DisplayName"
                        }

                        if ($IncludeCert) {
                            $PrintedCount++
                            $ExpiryStatus = if ($DaysToExpiry -lt 0) { "Expired" } else { "Active" }
                            $FriendlyExpiryTime = if ($DaysToExpiry -lt 0) { "Expired $([Math]::Abs($DaysToExpiry)) days ago" } else { "Expires in $DaysToExpiry days" }

                            $ExportResult = [PSCustomObject]@{
                                'App Name'           = $AppName
                                'App Owners'         = $Owners
                                'App Creation Time'  = $AppCreationDate
                                'Credential Type'    = "Certificate"
                                'Name'               = $DisplayName
                                'Id'                 = $Id
                                'Creation Time'      = $CreatedTime
                                'Expiry Date'        = $ExpiryDate
                                'Days to Expiry'     = $DaysToExpiry
                                'Friendly Expiry'    = $FriendlyExpiryTime
                                'App Id'             = $Application.AppId
                                'Status'             = $ExpiryStatus
                            }
                            $ExportResults += $ExportResult
                            Write-Information "Found expiring/expired certificate: $AppName - $DisplayName (Days to expiry: $DaysToExpiry)" -InformationAction $InformationPreference
                        }
                    }
                }
                #endregion
            }

            Write-Progress -Activity "Processing Application Registrations" -Completed -ProgressAction $ProgressPreference
            
            Write-Information "Credential scan complete: Found $PrintedCount expiring/expired credentials across $AppCount applications" -InformationAction $InformationPreference
            Write-Verbose "Credential scan complete!" -Verbose:$VerbosePreference
            Write-Verbose "Processed $TotalApps applications - Found $PrintedCount expiring/expired credentials" -Verbose:$VerbosePreference
            Write-Debug "[Get-OCM365AppRegistrationsExpiring] Scan complete - Total credentials found: $PrintedCount"

            return $ExportResults
        }
        catch {
            Write-Error "Failed to retrieve application registration credentials: $_" -ErrorAction Stop
            throw
        }
    }
}