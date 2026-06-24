# Disclaimer: Unofficial API Usage
This module interacts with internal or undocumented APIs from Clever that are not officially supported by the vendor.


What this means:

- These APIs are not publicly documented and may change or be removed without notice.
- There is no guarantee of stability or support from Clever.
- Use of this module is at your own risk, especially in production environments.


# Usage


### Find Charge points and chargers

```powershell
# Search for chargers by name
Get-CleverCharger -Search "Albertslund"
```
Output: 

```

coordinates      : @{quality=Unknown; lat=55,6711038344969; geohash=u3bu8y958t; altitude=; lng=12,3390478422305}
revision         : 155
isCanopy         : False
roamingAgreement : 
locationId       : 7db0c70e-0e14-ef11-9f89-000d3a696be7
origin           : Clever
operator         : @{partyId=CLE; displayName=; name=Clever; countryCode=DK}
state            : Active
plugTypes        : {@{speed=Rapid; plugType=CCS}}
evseMetadata     : {@{plugType=CCS; speed=Rapid; evseIds=System.Object[]}}
timestamp        : @{type=firestore/timestamp/1.0; seconds=1780272204; nanoseconds=638768000}
name             : Netto Egelundsvej - Albertslund

coordinates      : @{lat=55,6584015258316; quality=Unknown; geohash=u3bu9h699q; altitude=; lng=12,3521255973479}
locationId       : 91448a33-2737-f011-8c4d-000d3ab1ea3c
allowIo          : True
operator         : @{partyId=CLE; name=Clever; displayName=; countryCode=DK}
state            : Active
origin           : Clever
timestamp        : @{type=firestore/timestamp/1.0; seconds=1780273629; nanoseconds=437120000}
name             : Albertslund Station
revision         : 4
roamingAgreement : 
isCanopy         : False
plugTypes        : {@{speed=Standard; plugType=Type2}}
evseMetadata     : {@{speed=Standard; plugType=Type2; evseIds=System.Object[]}}
```

### Get details about a charge point

```powershell
# Get charger Details
Get-CleverCharger -Search "Albertslund" | Get-CleverChargerDetail
```

Output:

```
address             : @{address=Egelundsvej 24; city=Albertslund; countryCode=DK; postalCode=2620; state=}
locationId          : 7db0c70e-0e14-ef11-9f89-000d3a696be7
name                : Netto Egelundsvej - Albertslund
coordinates         : @{lat=55,6711038344969; lng=12,3390478422305; geohash=u3bu8y958t}
plugs               : {@{icon=icon-plug-ccs; label=CCS · 150; isAvailable=True; available=2; total=2; connectors=System.Object[]; prices=Sy
                      stem.Object[]}}
outOfOrder          : {}
type                : clever
partnerStatus       : None
operator            : @{partyId=CLE; displayName=; countryCode=DK; name=Clever}
origin              : Clever
serviceInformations : {}
state               : Active
openAllDay          : True
hours               : {}
isCurrentlyOpen     : True
locationMapLink     : https://google.com/maps/search/?api=1&query=55.671103834496925,12.339047842230459

address             : @{address=Banehegnet 2; city=Albertslund; countryCode=DK; postalCode=2620; state=}
locationId          : 91448a33-2737-f011-8c4d-000d3ab1ea3c
name                : Albertslund Station
coordinates         : @{lat=55,6584015258316; lng=12,3521255973479; geohash=u3bu9h699q}
plugs               : {@{icon=icon-plug-type-2; label=Type 2 · 22; isAvailable=True; available=7; total=8; connectors=System.Object[]; pric
                      es=System.Object[]}}
outOfOrder          : {}
type                : clever
partnerStatus       : None
operator            : @{countryCode=DK; name=Clever; partyId=CLE; displayName=}
origin              : Clever
serviceInformations : {}
state               : Active
openAllDay          : True
hours               : {}
isCurrentlyOpen     : True
locationMapLink     : https://google.com/maps/search/?api=1&query=55.658401525831614,12.352125597347872
```

### Check a charger is available.

```powershell
# The LocationId of the charge Point
$ChargerId = "7db0c70e-0e14-ef11-9f89-000d3a696be7"
# Sound file to play when the charger is available.
$AlertSound = "C:\Windows\Media\Alarm02.wav"
# To exit the while loop.
$Available = $false

do {
    # Get the charger details
    $Details = Get-CleverChargerDetail -LocationId $ChargerId
    $Available = $Details.plugs.isAvailable
} while ($Available -eq $false)

Write-Host "Charger is now available! GO CHARGE!" -ForegroundColor Green
(New-Object System.Media.SoundPlayer $($AlertSound)).Play()

```