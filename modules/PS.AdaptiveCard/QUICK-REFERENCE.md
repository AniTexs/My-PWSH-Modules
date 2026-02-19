# PS.AdaptiveCard - Quick Reference & Common Patterns

## Import Module
```powershell
Import-Module PS.AdaptiveCard
```

## Basic Patterns

### Simple Text Card
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "Hello World" -Size Large -Weight Bolder
)
```

### Card with Image
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardImage -Url "https://example.com/image.png" -Size Medium
    New-ACardTextBlock -Text "Caption text" -Subtle
)
```

### Two Column Layout
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardColumnSet -Columns @(
        New-ACardColumn -Items @(
            New-ACardTextBlock -Text "Left"
        ) -WeightedWidth -WidthValue 1
        
        New-ACardColumn -Items @(
            New-ACardTextBlock -Text "Right"
        ) -WeightedWidth -WidthValue 1
    )
)
```

### Simple Form
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardInputText -Id "name" -Label "Name" -IsRequired
    New-ACardInputText -Id "email" -Label "Email" -Style email
) -Actions @(
    New-ACardActionSubmit -Title "Submit"
)
```

### Facts Display
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardFactSet -Facts @(
        New-ACardFact -Title "Name" -Value "John Doe"
        New-ACardFact -Title "Title" -Value "Engineer"
        New-ACardFact -Title "Email" -Value "john@example.com"
    )
)
```

### Container with Style
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardContainer -Style Emphasis -Items @(
        New-ACardTextBlock -Text "Important Message" -Weight Bolder
        New-ACardTextBlock -Text "This container is emphasized" -Wrap
    )
)
```

### Dropdown Selection
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardInputChoiceSet -Id "country" -Label "Country" -Style compact -Choices @(
        New-ACardInputChoice -Title "USA" -Value "us"
        New-ACardInputChoice -Title "Canada" -Value "ca"
        New-ACardInputChoice -Title "UK" -Value "uk"
    )
)
```

### Radio Buttons
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardInputChoiceSet -Id "size" -Label "Size" -Style expanded -Choices @(
        New-ACardInputChoice -Title "Small" -Value "s"
        New-ACardInputChoice -Title "Medium" -Value "m"
        New-ACardInputChoice -Title "Large" -Value "l"
    )
)
```

### Action Buttons
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "Choose an action"
) -Actions @(
    New-ACardActionSubmit -Title "Approve" -Style Positive -Data @{action="approve"}
    New-ACardActionSubmit -Title "Reject" -Style Destructive -Data @{action="reject"}
    New-ACardActionOpenUrl -Title "Learn More" -Url "https://example.com"
)
```

### Simple Table
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardTable -ShowGridLines -Columns @(
        New-ACardTableColumnDefinition -Width 1
        New-ACardTableColumnDefinition -Width 2
    ) -Rows @(
        New-ACardTableRow -Cells @(
            New-ACardTableCell -Items @(New-ACardTextBlock -Text "Name")
            New-ACardTableCell -Items @(New-ACardTextBlock -Text "John Doe")
        )
        New-ACardTableRow -Cells @(
            New-ACardTableCell -Items @(New-ACardTextBlock -Text "Email")
            New-ACardTableCell -Items @(New-ACardTextBlock -Text "john@example.com")
        )
    )
)
```

### Rich Text
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardRichTextBlock -Inlines @(
        New-ACardTextRun -Text "This is "
        New-ACardTextRun -Text "bold" -Weight Bolder
        New-ACardTextRun -Text " and "
        New-ACardTextRun -Text "colored" -Color Attention
    )
)
```

### Badge Display
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardColumnSet -Columns @(
        New-ACardColumn -Items @(
            New-ACardBadge -Text "Active" -Style Good -Shape Circular
        ) -AutomaticWidth
        New-ACardColumn -Items @(
            New-ACardBadge -Text "Warning" -Style Attention -Shape Rounded
        ) -AutomaticWidth
    )
)
```

### Code Block
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardCodeBlock -Language PowerShell -Code @"
Get-Process | Where-Object CPU -gt 100
"@
)
```

### Card with Actions Header
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "Title" -Style Heading
    New-ACardTextBlock -Text "Description" -Wrap
    
    New-ACardActionSet -Actions @(
        New-ACardActionSubmit -Title "Action 1"
        New-ACardActionSubmit -Title "Action 2"
    )
)
```

### Profile Card Pattern
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardColumnSet -Columns @(
        New-ACardColumn -Items @(
            New-ACardImage -Url "https://example.com/avatar.png" -Style Person -Size Small
        ) -AutomaticWidth
        New-ACardColumn -Items @(
            New-ACardTextBlock -Text "John Doe" -Weight Bolder
            New-ACardTextBlock -Text "Senior Engineer" -Subtle
        ) -StretchWidth
    )
)
```

## Common Enums

### Text Sizes
- `Small`, `Default`, `Medium`, `Large`, `ExtraLarge`

### Text Weights
- `Lighter`, `Default`, `Bolder`

### Colors
- `Default`, `Dark`, `Light`, `Accent`, `Good`, `Warning`, `Attention`

### Container Styles
- `Default`, `Emphasis`, `Good`, `Attention`, `Warning`, `Accent`

### Spacing
- `None`, `ExtraSmall`, `Small`, `Default`, `Medium`, `Large`, `ExtraLarge`

### Alignments
- Horizontal: `Left`, `Center`, `Right`
- Vertical: `Top`, `Center`, `Bottom`

### Button Styles
- `Default`, `Positive`, `Destructive`

### Button Modes
- `Primary`, `Secondary`

### Badge Styles
- `Default`, `Subtle`, `Informative`, `Accent`, `Good`, `Attention`, `Warning`

### Badge Shapes
- `Default`, `Circular`, `Rounded`

## Tips & Tricks

### Always Wrap Long Text
```powershell
New-ACardTextBlock -Text "Long text..." -Wrap
```

### Mark Required Fields
```powershell
New-ACardInputText -Id "email" -Label "Email" -IsRequired -ErrorMessage "Email is required"
```

### Use Separators for Sections
```powershell
New-ACardTextBlock -Text "Section 2" -Separator
```

### Set Column Widths
```powershell
# Auto width
New-ACardColumn -AutomaticWidth -Items @(...)

# Stretch to fill
New-ACardColumn -StretchWidth -Items @(...)

# Weighted (relative)
New-ACardColumn -WeightedWidth -WidthValue 2 -Items @(...)
```

### Style Text Elements
```powershell
# Heading
New-ACardTextBlock -Text "Title" -Style Heading

# Column Header
New-ACardTextBlock -Text "Header" -Style ColumnHeader

# Subtle text
New-ACardTextBlock -Text "Subtitle" -Subtle

# Colored text
New-ACardTextBlock -Text "Important" -Color Attention
```

### Toggle Visibility
```powershell
# Element with ID
New-ACardTextBlock -Text "Hidden initially" -Id "details" -IsVisible $false

# Action to toggle
New-ACardActionToggleVisibility -Title "Show Details" -TargetElements @(
    New-ACardTargetElement -ElementId "details" -IsVisible $true
)
```

### Multi-select Input
```powershell
New-ACardInputChoiceSet -Id "interests" -IsMultiSelect -Choices @(
    New-ACardInputChoice -Title "Option 1" -Value "1"
    New-ACardInputChoice -Title "Option 2" -Value "2"
)
```

### Action with Data Payload
```powershell
New-ACardActionSubmit -Title "Approve" -Data @{
    action = "approve"
    id = "12345"
    timestamp = (Get-Date).ToString()
}
```

## Copy to Clipboard Pattern
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "My Card"
) | Set-Clipboard
```

## Save to File Pattern
```powershell
New-ACardAdaptiveCard -Body @(
    New-ACardTextBlock -Text "My Card"
) | Out-File -FilePath "card.json" -Encoding UTF8
```

## Test in Designer
1. Create your card in PowerShell
2. Copy the JSON output
3. Paste into https://adaptivecards.io/designer/
4. Preview and refine

## Quick Function Lookup

| Need | Function |
|------|----------|
| Text | `New-ACardTextBlock` |
| Image | `New-ACardImage` |
| Columns | `New-ACardColumnSet` + `New-ACardColumn` |
| Facts | `New-ACardFactSet` + `New-ACardFact` |
| Table | `New-ACardTable` + `New-ACardTableRow` + `New-ACardTableCell` |
| Container | `New-ACardContainer` |
| Text Input | `New-ACardInputText` |
| Dropdown | `New-ACardInputChoiceSet` (style: compact) |
| Radio | `New-ACardInputChoiceSet` (style: expanded) |
| Checkbox | `New-ACardInputToggle` |
| Date | `New-ACardInputDate` |
| Number | `New-ACardInputNumber` |
| Button | `New-ACardActionSubmit` |
| Link Button | `New-ACardActionOpenUrl` |
| Badge | `New-ACardBadge` |
| Code | `New-ACardCodeBlock` |
