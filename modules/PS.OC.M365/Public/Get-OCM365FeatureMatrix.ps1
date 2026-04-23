function Get-OCM365FeatureMatrix {
    [CmdletBinding()]
    param(
        [string]$Url = 'https://m365maps.com/Microsoft-365-Matrix.xlsx',
        [string]$WorksheetName,
        [switch]$AsHashtable
    )

    begin {
        $translateTable = @{
            '✔'  = 'Included'
            '⊡'  = 'Only available as part of a package'
            'Δ'  = 'Can be added to any license'
            '+'  = 'Can add-on to the license in this column'
            '~'  = 'Feature is only partially included'
            '--' = 'Not Included'
            '?'  = "Doesn't have licensing guidance yet"
        }

        function Get-XlsxBytes {
            param(
                [Parameter(Mandatory)]
                [string]$Uri
            )

            $handler = [System.Net.Http.HttpClientHandler]::new()
            $client = [System.Net.Http.HttpClient]::new($handler)

            try {
                $response = $client.GetAsync($Uri).GetAwaiter().GetResult()
                $response.EnsureSuccessStatusCode() | Out-Null
                $bytes = $response.Content.ReadAsByteArrayAsync().GetAwaiter().GetResult()

                if (-not $bytes -or $bytes.Length -lt 4) {
                    throw "Downloaded content is empty or too small to be a valid workbook."
                }

                return $bytes
            }
            finally {
                $client.Dispose()
                $handler.Dispose()
            }
        }

        function Convert-MatrixValue {
            param(
                [AllowNull()]
                [object]$Value
            )

            if ($null -eq $Value) {
                return $null
            }

            $text = [string]$Value
            $text = $text.Trim()

            if ([string]::IsNullOrWhiteSpace($text)) {
                return $null
            }

            if ($translateTable.ContainsKey($text)) {
                return $translateTable[$text]
            }

            return $text
        }

        function Get-WorksheetHeaders {
            param(
                [Parameter(Mandatory)]
                [OfficeOpenXml.ExcelWorksheet]$Worksheet,
                [int]$HeaderRow = 2
            )

            $headers = [System.Collections.Generic.List[string]]::new()

            for ($col = 1; $col -le $Worksheet.Dimension.End.Column; $col++) {
                $headerText = $Worksheet.Cells[$HeaderRow, $col].Text
                $headerText = if ($null -ne $headerText) { $headerText.Trim() } else { '' }

                if ([string]::IsNullOrWhiteSpace($headerText)) {
                    $headerText = "Column$col"
                }

                $headers.Add($headerText)
            }

            return $headers
        }

        function Test-IsGroupRow {
            param(
                [Parameter(Mandatory)]
                [OfficeOpenXml.ExcelWorksheet]$Worksheet,

                [Parameter(Mandatory)]
                [int]$Row,

                [Parameter(Mandatory)]
                [string[]]$Headers
            )

            $featureText = $Worksheet.Cells[$Row, 1].Text
            $featureText = if ($null -ne $featureText) { $featureText.Trim() } else { '' }

            if ([string]::IsNullOrWhiteSpace($featureText)) {
                return $false
            }

            $featureCell = $Worksheet.Cells[$Row, 1]

            # Strongest signal in this workbook:
            # section/header rows are bold in the Feature column.
            if ($featureCell.Style.Font.Bold) {
                return $true
            }

            return $false
        }

        function Convert-WorksheetToFeatureObjects {
            param(
                [Parameter(Mandatory)]
                [OfficeOpenXml.ExcelWorksheet]$Worksheet
            )

            if ($null -eq $Worksheet.Dimension) {
                return @()
            }

            $headerRow = 2
            $dataStartRow = 3
            $endRow = $Worksheet.Dimension.End.Row
            $endCol = $Worksheet.Dimension.End.Column

            $headers = Get-WorksheetHeaders -Worksheet $Worksheet -HeaderRow $headerRow

            $results = [System.Collections.Generic.List[object]]::new()
            $currentGroup = $null

            for ($row = $dataStartRow; $row -le $endRow; $row++) {

                $featureText = $Worksheet.Cells[$row, 1].Text
                $featureText = if ($null -ne $featureText) { $featureText.Trim() } else { '' }

                # Skip totally empty rows
                if ([string]::IsNullOrWhiteSpace($featureText)) {
                    $rowHasAnyValue = $false
                    for ($col = 2; $col -le $endCol; $col++) {
                        $text = $Worksheet.Cells[$row, $col].Text
                        if (-not [string]::IsNullOrWhiteSpace($text)) {
                            $rowHasAnyValue = $true
                            break
                        }
                    }

                    if (-not $rowHasAnyValue) {
                        continue
                    }
                }

                if (Test-IsGroupRow -Worksheet $Worksheet -Row $row -Headers $headers) {
                    $currentGroup = $featureText
                    continue
                }

                $out = [ordered]@{
                    Group   = $currentGroup
                    Feature = if ([string]::IsNullOrWhiteSpace($featureText)) { $null } else { $featureText }
                    Diagram = $null
                }

                for ($col = 2; $col -le $endCol; $col++) {
                    $header = $headers[$col - 1]
                    $rawText = $Worksheet.Cells[$row, $col].Text
                    $rawText = if ($null -ne $rawText) { $rawText.Trim() } else { $null }

                    if ($header -eq 'Diagram') {
                        $out['Diagram'] = if ([string]::IsNullOrWhiteSpace($rawText)) { $null } else { $rawText }
                        continue
                    }

                    $out[$header] = Convert-MatrixValue -Value $rawText
                }

                $results.Add([pscustomobject]$out)
            }

            return $results
        }

        $xlsxBytes = Get-XlsxBytes -Uri $Url
        $stream = [System.IO.MemoryStream]::new($xlsxBytes, 0, $xlsxBytes.Length, $false, $true)

        try {
            $stream.Position = 0

            $excelPackage = [OfficeOpenXml.ExcelPackage]::new($stream)

            try {
                if ($WorksheetName) {
                    $worksheet = $excelPackage.Workbook.Worksheets[$WorksheetName]
                    if ($null -eq $worksheet) {
                        throw "Worksheet '$WorksheetName' was not found."
                    }
                }
                else {
                    $worksheet = $excelPackage.Workbook.Worksheets | Select-Object -First 1
                    if ($null -eq $worksheet) {
                        throw "No worksheets were found in the workbook."
                    }
                }

                $matrix = Convert-WorksheetToFeatureObjects -Worksheet $worksheet
            }
            finally {
                $excelPackage.Dispose()
            }
        }
        finally {
            $stream.Dispose()
        }
    }

    process {
        if ($AsHashtable) {
            $result = [ordered]@{}

            foreach ($country in $countries) {
                if ($WithSubdivisions) {
                    $result[$country.Code] = [PSCustomObject]@{
                        Country      = $country.Country
                        Subdivisions = $country.Subdivisions
                    }
                }
                else {
                    $result[$country.Code] = $country.Country
                }
            }

            return $result
        }
        else {
            $matrix | Select-Object -SkipLast 7 -ExcludeProperty Diagram
        }
    }
}