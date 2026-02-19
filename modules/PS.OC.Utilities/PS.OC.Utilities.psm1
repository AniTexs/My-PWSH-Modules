#Load classes first
$Classes = @( Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue )
Foreach($import in $Classes)
{
    Try
    {
        Write-Verbose "Importing class $($import.fullname)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import class $($import.fullname): $_"
    }
}

#Get public and private function definition files.
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        Write-Verbose "Importing function $($import.fullname)"
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
