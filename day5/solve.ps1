
function Get-StringHash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$String,

        [Parameter(Mandatory)]
        [ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
        [string]$Algorithm
    )
    $enc = [System.Text.Encoding]::UTF8
    $stream = [System.IO.MemoryStream]::new($enc.GetBytes($String))
    (Get-FileHash -InputStream $stream -Algorithm $Algorithm).Hash.ToLower()
}

Write-Warning -Message "This script will succeed but is very slow!"

$doorid = 'ugkcyxxp'
$code1 = ''
$code2 = [char[]]$('_' * 8)
$i = 0

while ($code1.Length -lt 8 -or '_' -in $code2) {
    $src = $doorid + $i.ToString()
    $hsh = Get-StringHash $src -Algorithm MD5
    $pos, $val = $hsh[5,6]
    if ($hsh.StartsWith('00000')) {
        $code1 += $pos
        $pos = $pos -match '[0-7]' ? [int][string]$pos : $pos
        if ($pos -in 0..7 -and $code2[$pos] -eq '_') {
            $code2[$pos] = $val
            Write-Host "`r$($code2 | Join-String)" -NoNewline
        }
    }
    $i++
}

$code1 = $code1.SubString(0,8)
$code2 = $code2 | Join-String

"`rPart 1: $code1"
"Part 2: $code2"
