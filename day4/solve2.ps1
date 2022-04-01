
function Get-DecodedString {
    param(
        [string]$Data,
        [int]$Id
    )
    $enc = [System.Text.Encoding]::UTF8
    
    $enc.GetBytes($Data) | ForEach-Object { 
        if ( $enc.GetString($_) -eq '-' ) { ' ' }
        else {
            $enc.GetString((($_ - 97 + $Id) % 26) + 97) 
        }
    } | Join-String
}

function Get-Checksum {
    param(
        [string]$Data
    )
    $CustomSort = @{Expression = 'Count'; Descending = $true},
                  @{Expression = 'Name'; Ascending = $true}
    $ltrs = $Data.Replace('-', '').ToCharArray()
    $sorted = $ltrs | Group-Object -NoElement | Sort-Object $CustomSort
    $sorted.Name[0..4] | Join-String
}

$lines = Get-Content -Path "$PSScriptRoot\input.txt"

$pattern = [Regex]::new('([a-z-]+)-(\d+)\[(\w+)\]')

$objects = $pattern.Matches($lines) | ForEach-Object {
    [PSCustomObject]@{
        Id       = [int]$_.Groups[2].Value
        Data     = $_.Groups[1].Value
        Decoded  = $null
        Checksum = $_.Groups[3].Value
        Checkval = $null
        Valid    = $null
    }
}

foreach ($obj in $objects) {
    $obj.Decoded  = Get-DecodedString -Data $obj.Data -Id $obj.Id
    $obj.Checkval = Get-Checksum -Data $obj.Data
    $obj.Valid    = ($obj.Checksum -eq $obj.Checkval)
}

# Part 1
$idsum = ($objects | Where-Object Valid -eq $true | Select-Object -Expand Id | Measure-Object -Sum).Sum

# Part 2
$sectorid = $objects | Where-Object Decoded -match 'northpole' | Select-Object -Expand Id

"Part 1: $idsum"
"Part 2: $sectorid"
