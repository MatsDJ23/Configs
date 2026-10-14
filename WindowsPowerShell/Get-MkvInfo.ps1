param(
    [Parameter(Position = 0)]
    [string]$Path = "*.mkv"
)

function Get-MkvInfo {
    param([string]$File)

    $json = ffprobe -v error -select_streams v:0 `
        -show_entries stream=codec_name,width,height `
        -show_entries format=duration,size,bit_rate `
        -of json "$File" | ConvertFrom-Json

    if (-not $json.streams -or -not $json.format) {
        Write-Warning "Could not read: $File"
        return
    }

    $v = $json.streams[0]
    $f = $json.format

    [PSCustomObject]@{
        File       = Split-Path $File -Leaf
        Resolution = "$($v.width)x$($v.height)"
        Codec      = $v.codec_name
        Bitrate    = if ($f.bit_rate) {
            "{0:N1} Mbps" -f ([double]$f.bit_rate / 1000000)
        } else { "Unknown" }
        Size       = "{0:N2} GB" -f ([double]$f.size / 1e9)
        Duration   = [TimeSpan]::FromSeconds(
            [double]$f.duration
        ).ToString("hh\:mm\:ss")
    }
}

$files = Get-ChildItem -Path $Path -File -ErrorAction SilentlyContinue

if (-not $files) {
    Write-Host "No matching files found: $Path"
    exit
}

$files | ForEach-Object {
    try {
        Get-MkvInfo -File $_.FullName
    } catch {
        Write-Warning "Failed to read $($_.Name): $_"
    }
} | Format-Table -AutoSize