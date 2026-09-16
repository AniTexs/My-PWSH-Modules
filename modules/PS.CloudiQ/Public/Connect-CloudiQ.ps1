function Connect-CloudiQ {
    [CmdletBinding(DefaultParameterSetName = 'ByPassEnvironment')]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ClientId,
        [Parameter(Mandatory = $true)]
        [string]
        $ClientSecret,
        [Parameter(ParameterSetName = 'ByPassEnvironment', Position = 3)]
        [string]
        $CloudiQUsername,
        [Parameter(ParameterSetName = 'ByPassEnvironment', Position = 4)]
        [SecureString]
        $CloudiQPassword,
        [Parameter(ParameterSetName = 'Credential')]
        [PSCredential]
        $Credential
    )
    # Variables used....
    $apiBaseUrl = 'https://api.crayon.com/api/v1'
    $CloudiQCredentials = $null
    # Headers
    $headers = @{}
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($ClientId + ":" + $ClientSecret)
    $EncodedText = [Convert]::ToBase64String($Bytes)
    $headers.Add("Authorization", "Basic " + $EncodedText)
    $headers.Add("Content-Type", "application/x-www-form-urlencoded")


    # Credentials for Password Grant
    switch ($PSCmdlet.ParameterSetName) {
        'ByPassEnvironment' {
            if (!$CloudiQUsername) {
                # Backwards compatability with old Module
                if ($Env:CloudiQUsername) {
                    $CloudiQUsername = $Env:CloudiQUsername
                }
                else {
                    # I aint gonna ask the user!
                    throw "CloudiQUsername is required."
                }
            }

            if (!$CloudiQPassword) {
                if ($Env:CloudiQPassword) {
                    $CloudiQPassword = ($Env:CloudiQPassword | ConvertTo-SecureString -AsPlainText -Force)
                }
                else {
                    throw "CloudiQPassword is required."
                }
            }

            # New PSCredential object
            $CloudiQCredentials = New-Object System.Management.Automation.PSCredential ($CloudiQUsername, $CloudiQPassword)
        }
        'Credential' {
            if (!$Credential) {
                throw "Credential is required."
            }
            $CloudiQCredentials = $Credential
        }
    }

    $Body = @{
        'username'   = $CloudiQCredentials.UserName
        'password'   = $CloudiQCredentials.GetNetworkCredential().Password
        'grant_type' = "password"
        'scope'      = "CustomerApi"
    }

    try {
        $callParam = @{
            Uri     = "$apiBaseUrl/connect/token/"
            Method  = 'POST'
            Body    = $Body
            Headers = $headers
        }
        $OAuthReq = Invoke-RestMethod @callParam
        $Script:oAuthObject = @{
            'access_token'  = $OAuthReq.AccessToken
            'token_type'    = $OAuthReq.TokenType
            'expires_in'    = $OAuthReq.ExpiresIn
            'expires_at'    = (get-date).AddSeconds($OAuthReq.ExpiresIn)
        }
        $ConnectedUser = Invoke-Api -Path "/me"
        $Script:oAuthObject.User_Id = $ConnectedUser.UserId
        $Script:oAuthObject.Username = $ConnectedUser.Username
    }
    catch {
        Write-Error $_.Exception.Message
        break
    }

    Write-Verbose "Successfully connected to Cloud-iQ via PS.CloudiQ"
}