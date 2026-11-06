# File function veriables
$Execute = "$HOME\Documents\WindowsPowerShell\Execute-C.ps1"
$VidInfo = "$HOME\Documents\WindowsPowerShell\Get-VidInfo.ps1"
$ServerIP = "$HOME\Documents\WindowsPowerShell\Server-IP.ps1"

# any custom commands created will be optional, there is an if else check before the given command is executed to check if the file exists
if (Test-Path $Execute) {Write-Host "Execute main.c (compiles and runs the gives C file)" -ForegroundColor Yellow}
if (Test-Path $VidInfo) {Write-Host "Get video file info by using: vidinfo file.mkv (for mkv and mp4)" -ForegroundColor Yellow}
Write-Host ""
if (Test-Path $ServerIP) { & $ServerIP }

function prompt {
    $user = $env:USERNAME
    $currentPath = (Get-Location).Path
    $homePath = $HOME

    # Show '~' if in home directory, otherwise show the current folder name
    if ($currentPath -eq $homePath) {
        $folder = "~"
    } else {
        $folder = Split-Path -Leaf $currentPath
    }

    # Output styled text directly using PowerShell color parameters
    Write-Host "${user} " -ForegroundColor Green -NoNewline
    Write-Host "${folder} " -ForegroundColor DarkBlue -NoNewline
    Write-Host "$" -ForegroundColor Green -NoNewline

    return " "
}

function execute {
    if (Test-Path $Execute) {& $Execute @args} else {Write-Host "Execute-C.ps1 could not be found at $Execute" -ForegroundColor Red }
}

function vidinfo {
    if (Test-Path $VidInfo) {& $VidInfo @args} else {Write-Host "VidInfo.ps1 could not be found at $VidInfo" -ForegroundColor Red }
}
