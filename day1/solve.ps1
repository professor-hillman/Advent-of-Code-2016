using namespace System.Collections.Generic

$data = Get-Content "$PSScriptRoot\input.txt"

$p = [Regex]::new('([LR])(\d+)')

$data = $p.Matches($data) | ForEach-Object {
    $m1, $m2 = $_.Groups.Value[1..2]
    [PSCustomObject]@{
        Turn = $m1
        Step = [int]$m2
    }
}

$dirs = 'N', 'E', 'S', 'W'
$x, $y, $f = 0, 0, 0

$visited = [List[Array]]@()
$visited.Add( @($x, $y) )

foreach ($step in $data) {
    $t = ($step.Turn -eq 'R') ? 1 : -1
    $f = ($f + $t) % 4
    switch ($dirs[$f]) {
        N {
            $oy = $y + 1
            $y += $step.Step
            $oy..$y | ForEach-Object { $visited.Add( @($x, $_) ) }
        }
        S {
            $oy = $y - 1
            $y -= $step.Step
            $oy..$y | ForEach-Object { $visited.Add( @($x, $_) ) }
        }
        W {
            $ox = $x - 1
            $x -= $step.Step
            $ox..$x | ForEach-Object { $visited.Add( @($_, $y) ) }
        }
        E {
            $ox = $x + 1
            $x += $step.Step
            $ox..$x | ForEach-Object { $visited.Add( @($_, $y) ) }
        }
    }
}
$taxiDist1 = [Math]::Abs($x) + [Math]::Abs($y)
"Part 1: $taxiDist1"

$uniqueVisits = $visited | Select-Object -Unique
$repeatVisits = Compare-Object -ReferenceObject $uniquevisits -DifferenceObject $visited
$x2, $y2 = $repeatVisits | Select-Object -First 1 -ExpandProperty InputObject

$taxiDist2 = [Math]::Abs($x2) + [Math]::Abs($y2)
"Part 2: $taxiDist2"
