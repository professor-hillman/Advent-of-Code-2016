using namespace System.Drawing

function keypad1 {

    $xs = @( -1, 0, 1, -1, 0, 1, -1, 0, 1 )
    $ys = @( 1, 1, 1, 0, 0, 0, -1, -1, -1 )
    $cs = '123456789'

    $keypad = [ordered] @{}
    for ($i=0; $i -lt $xs.count; $i++) {
        $keypad.add(
            [Point]::new($xs[$i], $ys[$i]), $cs[$i]
            )
    }
    $keypad
}

function keypad2 {

    $xs = @( 0, -1, 0, 1, -2, -1, 0, 1, 2, -1, 0, 1, 0 )
	$ys = @( 2, 1, 1, 1, 0, 0, 0, 0, 0, -1, -1, -1, -2 )
	$cs = '123456789ABCD'

    $keypad = [ordered] @{}
    for ($i=0; $i -lt $xs.count; $i++) {
        $keypad.add(
            [Point]::new($xs[$i], $ys[$i]), $cs[$i]
            )
    }
    $keypad
}

function decode {
    param($pad, $data)
    
    $steps = @{
        [char]'R' = @(1, 0)
        [char]'L' = @(-1, 0)
        [char]'U' = @(0, 1)
        [char]'D' = @(0, -1)
    }
    
    $x, $y, $code = 0, 0, ''

    foreach ($line in $data) {
        foreach ($char in $line.ToCharArray()) {
            $xx, $yy = $steps[$char]
            $point = [Point]::new($x + $xx, $y + $yy)
            if ($pad.Contains($point)) {
                $x, $y = $point.x, $point.y
            } else {
                continue
            }
        }
        $code += $pad[ [Point]::new($x, $y) ]
    }
    return $code
}

$data = Get-Content "$PSScriptRoot\input.txt"

$pad1 = keypad1
$pad2 = keypad2

"Part 1: $(decode -pad $pad1 -data $data)"
"Part 2: $(decode -pad $pad2 -data $data)"
