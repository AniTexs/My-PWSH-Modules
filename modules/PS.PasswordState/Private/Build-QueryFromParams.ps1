function Build-QueryFromParams {
    <#
        .EXAMPLES
        Use inside of a function with parameters to build a query string from the bound parameters.
        function Test {
            [CmdletBinding()]
            param(
                [switch]$QueryAll,
                [string]$HashType = 'SHA256',
                [int]$Limit,
                [string[]]$Tags
            )
            $query = Build-QueryFromParams -PSCmdlet $PSCmdlet
            $query
        }
        Test -QueryAll -Tags red,blue

        Or

        Build-QueryFromParams -PSCmdlet $PSCmdlet -Include 'HashType','Limit'
        Build-QueryFromParams -PSCmdlet $PSCmdlet -Exclude 'Tags'
    #>
    [CmdletBinding(DefaultParameterSetName = 'Hashtable')]
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'PSCmdlet')]
        [Alias('PSCmdlet')]
        [System.Management.Automation.PSCmdlet]
        $Cmdlet, 
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'Hashtable')]
        [Hashtable]
        $Query, 
        [string[]]
        $Include, 
        [string[]]
        $Exclude,
        [switch]
        $IncludeOnlyWhenTrue
    )

    
    if (-not $PSBoundParameters.ContainsKey('Verbose')) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    switch ($PSCmdlet.ParameterSetName) {
        'Hashtable' {
            if (-not $Query) { return $null }
            $Params = $Query
        }
        'PSCmdlet' {
            if (-not $Cmdlet) { return $null }
            $h = @{}
            foreach ($name in $PSCmdlet.MyInvocation.MyCommand.Parameters.Keys) {
                # pull the local param variable (already holds default if not bound)
                $val = Get-Variable -Name $name -ValueOnly -ErrorAction SilentlyContinue
                $h[$name] = $val
            }
            # Optionally strip common params so they don't end up in your query
            $common = 'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
            'ErrorVariable', 'WarningVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable','Cmdlet'
            $common | ForEach-Object { $h.Remove($_) | Out-Null }

            $Params = $h
        }
    }
    

    

    $keys = $Params.Keys
    if ($Include) { $keys = $keys | Where-Object { $_ -in $Include } }
    if ($Exclude) { $keys = $keys | Where-Object { $_ -notin $Exclude } }

    $pairs = foreach ($k in $keys) {
        $v = $Params[$k]
        if ($null -eq $v) { continue }

        # switches/bools: include only when true
        if($IncludeOnlyWhenTrue.IsPresent){
            if ($v -is [bool]) { if (-not $v) { continue }; $v = $true }
        }

        # arrays: repeat the key
        if ($v -is [System.Collections.IEnumerable] -and -not ($v -is [string])) {
            foreach ($item in $v) {
                '{0}={1}' -f [uri]::EscapeDataString($k), [uri]::EscapeDataString([string]$item)
            }
            continue
        }

        '{0}={1}' -f [uri]::EscapeDataString($k), [uri]::EscapeDataString([string]$v)
    }

    if (-not $pairs) { return $null }
    '?' + ($pairs -join '&')
}