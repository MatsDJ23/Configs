# Custom text printed above the prompt line
Write-Host "Custom command: Execute main.c (compiles and runs the gives C file)" -ForegroundColor Yellow
# Print an empty line (Enter) first
Write-Host ""

# this custom command utilizes cl.exe for compiling, same as vscode but this you can use without it.

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
    $vcvars = "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"

    cmd /c "`"$vcvars`" x64 >nul && cl.exe /Zi /EHsc /nologo /Fe:`"$fileName.exe`" `"$file`" && `"$fileName.exe`""
}
