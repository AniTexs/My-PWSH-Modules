function Set-CloudiQOrganizationAccess {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]]
        # One or more OrganizationAccess objects to update
        $OrganizationAccess
    )
    begin {
        $AccessList = [System.Collections.Generic.List[object]]::new()
    }
    process {
        foreach ($Access in $OrganizationAccess) {
            $AccessList.Add($Access)
        }
    }
    end {
        if ($AccessList.Count -eq 0) {
            return
        }
        if ($PSCmdlet.ShouldProcess("$($AccessList.Count) organization access entr$(if($AccessList.Count -eq 1){'y'}else{'ies'})", 'Update')) {
            # -AsArray guarantees a JSON array even for a single entry
            $Body = $AccessList | ConvertTo-Json -Depth 10 -AsArray
            (Invoke-Api -Path "/OrganizationAccess" -Method Put -Payload $Body).Items
        }
    }
}
