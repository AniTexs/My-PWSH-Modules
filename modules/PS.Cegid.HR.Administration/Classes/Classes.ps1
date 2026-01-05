#region API Classes
class TSApiToken {
    [string]$access_token
    [string]$token_type
    [int]$expires_in
    [string]$scope
}

class TSApiSession {
    [TSApiToken]$Token
    [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession
    [string]$ClientId
    [string]$ClientSecret
    [string]$ApiBaseUri
    [string]$BaseUri
}
#endregion

#region Data Model Classes
class TSDeviceType {
    static [string] $Email = "Email"
    static [string] $MobilePhone = "MobilePhone"
    static [string] $Phone = "Phone"
    static [string] $Fax = "Fax"
    static [string] $InstantMessenger = "InstantMessenger"
}

class TSSex {
    static [string] $Male = "M"
    static [string] $Female = "F"
    static [string] $Unknown = "U"
}

class TSCivilStatus {
    static [string] $Single = "Single"
    static [string] $Married = "Married"
    static [string] $Divorced = "Divorced"
    static [string] $Widowed = "Widowed"
    static [string] $Separated = "Separated"
    static [string] $CivilUnion = "CivilUnion"
}

class TSNamingMethod {
    static [string] $EmployeeNumber = "EmployeeNumber"
    static [string] $UserName = "UserName"
}

class TSTypeSpecif {
    static [string] $CoreHr = "CoreHr"
    static [string] $Talent = "Talent"
    static [string] $Training = "Training"
}

class TSComDevice {
    [int]$rank
    [string]$deviceType
    [string]$value
    [bool]$isPreferred
    [string]$label
}

class TSUser {
    [string]$userName
    [string]$email
    [bool]$isActive
    [datetime]$creationDate
    [datetime]$modificationDate
}

class TSIndividual {
    [int]$id
    [string]$firstName
    [string]$lastName
    [string]$middleName
    [string]$preferredName
    [string]$civilStatus
    [string]$sex
    [datetime]$birthDate
    [string]$birthPlace
    [string]$nationality
    [TSUser]$user
    [TSComDevice[]]$comDevices
}

class TSEmployee {
    [int]$employeeNumber
    [datetime]$hiringDate
    [datetime]$seniorityDate
    [datetime]$leavingDate
    [string]$leavingReason
    [bool]$isActive
    [TSIndividual]$individual
}

class TSPostalAddress {
    [int]$rank
    [string]$addressLine1
    [string]$addressLine2
    [string]$addressLine3
    [string]$city
    [string]$postalCode
    [string]$state
    [string]$country
    [string]$label
    [bool]$isPreferred
}

class TSOrganization {
    [string]$organizationCode
    [string]$organizationName
    [int]$managerEmployeeNumber
    [string]$managerName
    [datetime]$startDate
    [datetime]$endDate
}

class TSAttachment {
    [int]$attachmentId
    [string]$fileName
    [string]$documentType
    [int]$employeeNumber
    [datetime]$uploadDate
    [datetime]$modificationDate
    [int]$fileSize
    [string]$mimeType
}

class TSPhotoMetadata {
    [int]$employeeNumber
    [string]$fileName
    [int]$fileSize
    [string]$sha256
    [datetime]$uploadDate
}

class TSSpecifNode {
    [string]$clientCode
    [string]$label
    [string]$parentClientCode
    [int]$level
    [bool]$isActive
}

class TSSpecif {
    [string]$clientCode
    [string]$label
    [string]$type
    [bool]$isActive
    [TSSpecifNode[]]$nodes
}

class TSKeyPropertyNode {
    [string]$specifClientCode
    [string]$specifNodeClientCode
    [datetime]$startDate
    [datetime]$endDate
}

class TSEmployeeFileInfo {
    [int]$employeeNumber
    [string]$firstName
    [string]$lastName
    [string]$email
    [datetime]$hiringDate
    [bool]$isActive
}

class TSPaginatedResult {
    [int]$count
    [int]$offset
    [int]$total
    [object[]]$items
}
#endregion
