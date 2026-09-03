# Custom text printed above the prompt line
Write-Host "Custom command: Execute main.c (compiles and runs the gives C file)" -ForegroundColor Yellow
# Print an empty line (Enter) first
Write-Host ""

# For execute main.c (or any c file to work) vscode build tools has to install this list of items:
# - Desktop development with C++
# Make sure the checklist only install these items:
# - MSVC Build Tools for x64/x86 (Latest)
# - C++ CMake tools for Windows
# - Windows 11 SDK (10.0.26100.8249)
# - MSVC AddressSanitizer
# - vcpkg package manager
# remove any other things on the optional list

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

function execute ($file) {
    if (-not $file) {
        Write-Host "Please specify a C file (e.g., execute main.c)" -ForegroundColor Red
        return
    }

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($file)

    # List of potential vcvarsall.bat locations across different PCs
    # if the command fails its likely that either of these paths is wrong
    $possiblePaths = @(
        "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat",
        "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat"
    )

    # Pick the first path in the list that exists on this machine
    $vcvars = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

    if (-not $vcvars) {
        Write-Host "Could not locate vcvarsall.bat on this system." -ForegroundColor Red
        return
    }

    # Run the build environment and execute
    cmd /c "`"$vcvars`" x64 >nul && cl.exe /Zi /EHsc /nologo /Fe:`"$fileName.exe`" `"$file`" && `"$fileName.exe`""
}
