function New-ACardAdaptiveCard {
    <#
    .SYNOPSIS
    Creates an Adaptive Card.

    .DESCRIPTION
    Creates the root Adaptive Card object and converts it to JSON.

    .PARAMETER Body
    Array of card elements to include in the card body. Required.

    .PARAMETER Actions
    Array of actions to display at the bottom of the card.

    .PARAMETER Version
    Adaptive Card schema version. Default is "1.6".

    .PARAMETER Style
    Visual style for the card container.

    .PARAMETER BackgroundImage
    Background image for the card (created with New-ACardBackgroundImage).

    .PARAMETER MinHeight
    Minimum height in pixels for the card.

    .PARAMETER VerticalAlign
    Controls vertical alignment of content within the card.

    .PARAMETER Speak
    Text to be spoken for accessibility.

    .PARAMETER Lang
    Language of the card content (e.g., "en-US").

    .EXAMPLE
    New-ACardAdaptiveCard -Body @(
        New-ACardTextBlock -Text "Hello World" -Size Large
    )

    .EXAMPLE
    New-ACardAdaptiveCard -Body @(
        New-ACardTextBlock -Text "Survey" -Style Heading
        New-ACardInputText -Id "feedback" -Label "Your Feedback" -IsMultiline
    ) -Actions @(
        New-ACardActionSubmit -Title "Submit"
    )
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable[]]
        $Body,

        [hashtable[]]
        $Actions,

        [Guid]
        $ProviderId,

        [string]
        $Version = "1.6",

        [PS.AdaptiveCard.Layout+ContainerStyle]
        $Style,

        [hashtable]
        $BackgroundImage,

        [int]
        $MinHeight,

        [PS.AdaptiveCard.Layout+VerticalAlignment]
        $VerticalAlign,

        [string]
        $Speak,

        [string]
        $Lang,

        [Switch]
        $HideOriginalBody
    )

    $card = @{
        "type"    = "AdaptiveCard"
        '$schema' = "https://adaptivecards.io/schemas/adaptive-card.json"
        "version" = $Version
        "body"    = $Body
    }

    if($ProviderId) { $card.originator = $ProviderId }

    if($HideOriginalBody.IsPresent){$card.hideOriginalBody = $true}
    if ($Actions) { $card.actions = $Actions }
    if ($Style) { $card.style = $Style.ToString().ToLower() }
    if ($BackgroundImage) { $card.backgroundImage = $BackgroundImage }
    if ($MinHeight) { $card.minHeight = "$($MinHeight)px" }
    if ($VerticalAlign) { $card.verticalContentAlignment = $VerticalAlign.ToString().ToLower() }
    if ($Speak) { $card.speak = $Speak }
    if ($Lang) { $card.lang = $Lang }

    $card | ConvertTo-Json -Depth 50
}