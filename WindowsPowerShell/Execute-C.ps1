# For execute main.c (or any c file to work) vscode build tools has to install this list of items:
# - Desktop development with C++
# Make sure the checklist only install these items:
# - MSVC Build Tools for x64/x86 (Latest)
# - C++ CMake tools for Windows
# - Windows 11 SDK (10.0.26100.8249)
# - MSVC AddressSanitizer
# - vcpkg package manager
# remove any other things on the optional list

param(
    [Parameter(Position = 0)]
    [string]$file
)

if (-not $file) {
    Write-Host "Please specify a C file (e.g., execute main.c)" -ForegroundColor Red
    return
}

$fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)

# if the command fails its likely that either of these paths is wrong
$possiblePaths = @(
    "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat",
    "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat"
)

$vcvars = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $vcvars) {
    Write-Host "Could not locate vcvarsall.bat on this system. Make sure you went through the checklist in Execute-C.ps1" -ForegroundColor Red
    return
}

cmd /c "`"$vcvars`" x64 >nul && cl.exe /Zi /EHsc /nologo /Fe:`"$fileName.exe`" `"$file`" && `"$fileName.exe`""