function Send-GWSMS {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateLength(1, 11)]
        [string]
        $SendAs,
        [Parameter(Mandatory)]
        [String]
        $Message,
        [Parameter(Mandatory)]
        [string]
        $Recipient,
        [Switch]
        $Priority,
        [string]
        $Reference,
        [string]
        $Label,
        [DateTime]
        $Expiration
    )
    $BodyParams = @{
        sender = $SendAs
        message = $Message
        recipient = $Recipient
        priority = $Priority.IsPresent ? "urgent" : "normal"
    }
    if($Reference) {
        $BodyParams.reference = $Reference
    }
    if($Label) {
        $BodyParams.label = $Label
    }
    if($Expiration) {
        $BodyParams.expiration = Get-Date $Expiration -Format "yyyy-MM-ddTHH:mm:ss.fZ"
    }
    Invoke-GWRequest -Method Post -Path '/mobile/single' -Body $BodyParams
}