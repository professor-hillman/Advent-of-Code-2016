
$data = Get-Content "$PSScriptRoot\input.txt"

$h, $w = $data.length, $data[0].length

$list = New-Object System.Collections.Generic.List[string]

for ($i=0; $i -lt $w; $i++) {
    $col = ''
    for ($j=0; $j -lt $h; $j++) {
        $col += $data[$j][$i]
    }
    $list.add($col)
}

$msg_checksum = ''
$msg_original = ''

foreach ($str in $list) {
    $letters = $str.ToCharArray() | Group-Object -NoElement | Sort-Object Count -Descending
    $msg_checksum += $letters | Select-Object -First 1 -Expand Name
    $msg_original += $letters | Select-Object -Last 1 -Expand Name
}

"Part 1: $msg_checksum"
"Part 2: $msg_original"
