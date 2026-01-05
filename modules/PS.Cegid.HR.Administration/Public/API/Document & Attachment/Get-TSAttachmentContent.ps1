function Get-TSAttachmentContent {
    <#
    .SYNOPSIS
    Download the content of an attachment.
    
    .DESCRIPTION
    Retrieves the actual file content of a document attached to an employee.
    Requires permission: ADM_EXPORT_INDIVIDUALATTACHMENT
    
    .PARAMETER AttachmentId
    The attachment ID.
    
    .PARAMETER OutFile
    Optional path to save the downloaded file.
    
    .EXAMPLE
    Get-TSAttachmentContent -AttachmentId 12345 -OutFile "C:\Downloads\document.pdf"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int]
        $AttachmentId,
        
        [Parameter()]
        [string]
        $OutFile
    )
    
    process {
        Write-Verbose "[Get-TSAttachmentContent] Downloading attachment $AttachmentId"
        Write-Debug "[Get-TSAttachmentContent] OutFile: $OutFile"
        
        try {
            $response = Invoke-TSApi -Path "/directory/attachments/$AttachmentId/content" -Method "GET"
            
            if ($OutFile) {
                Write-Verbose "[Get-TSAttachmentContent] Saving attachment content to: $OutFile"
                
                $directory = Split-Path -Path $OutFile -Parent
                if ($directory -and -not (Test-Path -LiteralPath $directory)) {
                    Write-Verbose "[Get-TSAttachmentContent] Creating directory: $directory"
                    New-Item -ItemType Directory -Path $directory -Force | Out-Null
                }
                
                if ($response -is [byte[]]) {
                    [System.IO.File]::WriteAllBytes($OutFile, $response)
                }
                else {
                    $contentToWrite = $response
                    if (-not ($contentToWrite -is [string])) {
                        $contentToWrite = $contentToWrite | Out-String
                    }
                    [System.IO.File]::WriteAllText($OutFile, $contentToWrite)
                }
                
                Write-Verbose "[Get-TSAttachmentContent] Attachment content saved to: $OutFile"
            }
            
            Write-Verbose "[Get-TSAttachmentContent] Successfully downloaded attachment"
            return $response
        }
        catch {
            Write-Debug "[Get-TSAttachmentContent] Failed to download attachment: $_"
            throw
        }
    }
}