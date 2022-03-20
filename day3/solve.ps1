
function Get-Numbers {
    param ($FilePath)

    $content = Get-Content $FilePath
    $parsed = $content | Select-String '-?\d+' -AllMatches
    $lengths = @()
    $parsed.Matches.Value | ForEach-Object {
        $lengths += [int]$_
    }
    return $lengths
}

function Group-ArrayItems {
    param ($GroupSize, $Objects)

    $n = $GroupSize
    $groups = New-Object System.Collections.ArrayList
    for ($i=0; $i -lt $Objects.Length; $i=$i+$n) {
        [void]$groups.Add($Objects[$i..($i+$n-1)])
    }
    return $groups
}

function Merge-Columns {
    param ($Groups)

    $C1, $C2, $C3 = @(), @(), @()
    $Groups | ForEach-Object {
        $a, $b, $c = $_
        $C1 += $a
        $C2 += $b
        $C3 += $c
    }
    return $C1 + $C2 + $C3    
}

function Measure-Triangles {
    param ($ListOfSides)

    $count = 0
    $ListOfSides | ForEach-Object {
        $a, $b, $c = $_
        if (($a + $b -gt $c) -and ($b + $c -gt $a) -and ($a + $c -gt $b)) {
            $count += 1
        }
    }
    return $count
}

$lengths = Get-Numbers -FilePath "day3\input.txt"
$triplets = Group-ArrayItems -GroupSize 3 -Objects $lengths
$triangles = Measure-Triangles -ListOfSides $triplets

$triangles


$flattened = Merge-Columns -Groups $triplets
$triplets = Group-ArrayItems -GroupSize 3 -Objects $flattened
$triangles = Measure-Triangles -ListOfSides $triplets

$triangles

