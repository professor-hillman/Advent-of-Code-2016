
function Get-IPv7Nets {
    [CmdletBInding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$Address
    )
    $p = [regex]::new('\[(\w+)\]')
    $hypernets = $p.matches($Address).Groups | Where-Object Name -eq 1 | Select-Object -Expand Value
    foreach ($hypernet in $hypernets) {
        $Address = $Address.Replace($hypernet, '')
    }
    $supernets = $Address -split '\[\]'
    $supernets, $hypernets
}

function Get-RollingWindow {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$String,

        [Parameter(Mandatory)]
        [Alias('WindowLength')]
        [int]$n
    )
    $windows = @()
    for ($i=0; $i -lt ($string.length - ($n - 1)); $i++) {
        $windows += $string[$i..($i+($n-1))] | Join-String
    }
    $windows
}

function Get-Babs {
    param($Address)
    $supernets, $null = Get-IPv7Nets $Address
    $supernets | ForEach-Object {
        Get-RollingWindow $_ -WindowLength 3 | ForEach-Object {
            ( $_[0] -eq $_[2] -and $_[0] -ne $_[1] ) ? $("{1}{0}{1}" -f $_[0],$_[1]) : $null
        }
    } | Select-Object -Unique
}

function Assert-TLS {
    param($Address)
    $sncount, $hncount = 0, 0
    $supernets, $hypernets = Get-IPv7Nets $Address
    $supernets | ForEach-Object {
        Get-RollingWindow $_ -WindowLength 4 | ForEach-Object {
            if (($_[0] -eq $_[3]) -and ($_[1] -eq $_[2]) -and ($_[0] -ne $_[1])) {
                $sncount += 1
            }
        }
    }
    $hypernets | ForEach-Object {
        Get-RollingWindow $_ -WindowLength 4 | ForEach-Object {
            if (($_[0] -eq $_[3]) -and ($_[1] -eq $_[2]) -and ($_[0] -ne $_[1])) {
                $hncount += 1
            }
        }
    }
    (($sncount -gt 0) -and ($hncount -eq 0)) ? $true : $false
}

function Assert-SSL {
    param($Address)
    $babs = Get-Babs -Address $Address
    $null, $hypernets = Get-IPv7Nets $Address
    foreach ($hypernet in $hypernets) {
        foreach ($bab in $babs) {
            if ($hypernet -match $bab) {
                return $true
            }
        }
    } return $false
}

$data = Get-Content "$PSScriptRoot\input.txt"

$tls = ( $data.ForEach({ Assert-TLS $_ }) | Measure-Object -Sum ).Sum
$ssl = ( $data.ForEach({ Assert-SSL $_ }) | Measure-Object -Sum ).Sum

"Part 1: $tls"
"Part 2: $ssl"
