
$lines = Get-Content -Path 'day4/input.txt'

$ids = $lines | Select-String -Pattern '\d+' -AllMatches
$ids = $ids.Matches.Value | ForEach-Object { [int]$_ }

$checksums = $lines | Select-String -Pattern '\[(\w+)\]' -AllMatches
$checksums = $checksums.Matches | ForEach-Object { $_.Groups[1].Value }

function Get-Checksum {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]
        $Data
    )
    begin {
        $checksums = New-Object System.Collections.ArrayList
        $CustomSort = @{Expression = 'Count'; Descending = $true},
                       @{Expression = 'Name'; Descending = $false}
    }
    process {
        $ltrs = $Data -Split '-' | Select-Object -SkipLast 1 | Join-String
        $sorted = $ltrs.ToCharArray() | Group-Object -NoElement | Sort-Object $CustomSort
        $checksum = $sorted.Name[0..4] | Join-String
        $checksums.Add($checksum) | Out-Null
    }
    end {
        return $checksums
    }  
}

function Get-DecodedString {
    param(
        [string]$Data,
        [int]$Id
    )
    begin {
        $enc = [System.Text.Encoding]::UTF8
    }
    process {
        $ltrs = $Data -Split '-' | Select-Object -SkipLast 1 | Join-String
        $bytes = $enc.GetBytes($ltrs) | ForEach-Object {
            (($_ - 97 + $Id) % 26) + 97
        }
        $decoded = $enc.GetString($bytes)
    }
    end {
        return $decoded
    }
}

$actualChecksums = $lines | Get-Checksum

$idsum = 0
for ($i=0; $i -lt $checksums.count; $i++) {
    if ($actualChecksums[$i] -eq $checksums[$i]) {
        $idsum += $ids[$i]
    }
}
Write-Output "Part 1: $idsum"

for ($i=0; $i -lt $lines.count; $i++) {
    $decoded = Get-DecodedString -Data $lines[$i] -Id $ids[$i]
    if ($decoded -like '*northpole*') {
        $sectorid = $ids[$i]
    }
}
Write-Output "Part 2: $sectorid"
