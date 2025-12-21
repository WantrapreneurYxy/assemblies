@echo off
if "%~1"=="__LOG__" goto :MAIN

REM ==========================================
REM Wrapper: Redirects output to log.txt
REM ==========================================
echo [INFO] Running setup and run script...
echo [INFO] Output is being redirected to log.txt. Please wait...
call "%~f0" __LOG__ > log.txt 2>&1
echo.
echo [INFO] Execution finished. Displaying log.txt content:
echo -----------------------------------------------------
type log.txt
echo -----------------------------------------------------
pause
exit /b

:MAIN
REM ==========================================
REM Main Logic Section
REM ==========================================
setlocal EnableDelayedExpansion
cd /d "%~dp0"

echo ===========================================
echo      Assemblies Project Setup And Run
echo ===========================================

REM 1. Determine which Python command to use
REM Search for the highest version of Python available
echo [INFO] Searching for the highest version of Python...

set "PYTHON_CMD="

REM Method 1: Try Python Launcher (py.exe) - usually finds the latest installed version
py -3 -c "import sys; print(sys.executable)" >nul 2>&1
if !errorlevel! equ 0 (
    for /f "tokens=*" %%i in ('py -3 -c "import sys; print(sys.executable)"') do set "PYTHON_CMD=%%i"
    goto :FOUND_PYTHON
)

REM Method 2: PowerShell search for highest version in PATH (skipping WindowsApps stubs)
REM This finds all 'python' executables, checks their version, and picks the highest.
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "$best=$null; $bestVer=[version]'0.0'; Get-Command python -All -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source | ForEach-Object { if ($_ -notmatch 'WindowsApps') { try { $vStr = & $_ --version 2>&1; if ($vStr -match 'Python (\d+\.\d+)') { $v=[version]$matches[1]; if ($v -gt $bestVer) { $bestVer=$v; $best=$_ } } } catch {} } }; if ($best) { Write-Output $best }"`) do set "PYTHON_CMD=%%i"

if defined PYTHON_CMD goto :FOUND_PYTHON

REM Method 3: Fallback to standard 'python' command
where python >nul 2>&1
if !errorlevel! equ 0 (
    set PYTHON_CMD=python
    goto :FOUND_PYTHON
)

echo [ERROR] No suitable Python installation found.
echo Please install Python 3.9+ from python.org.
echo IMPORTANT: Check "Add Python to PATH" during installation.
exit /b 1

:FOUND_PYTHON
echo [INFO] Using Python command: !PYTHON_CMD!

REM 2. Create venv if it doesn't exist
if not exist .venv (
    echo [INFO] Creating virtual environment .venv...
    "!PYTHON_CMD!" -m venv .venv
    if !errorlevel! neq 0 (
        echo [ERROR] Failed to create virtual environment.
        exit /b 1
    )
)

REM 3. Activate venv
if not exist .venv\Scripts\activate (
    echo [ERROR] Virtual environment scripts not found. Creation might have failed.
    exit /b 1
)

call .venv\Scripts\activate

REM 4. Install dependencies
echo [INFO] Installing dependencies from requirements.txt...
pip install -r requirements.txt
if !errorlevel! neq 0 (
    echo [ERROR] Failed to install dependencies.
    exit /b 1
)

echo [INFO] Environment setup complete.
echo.
echo ==========================================
echo      Running parser.py (Demo)
echo ==========================================
echo.

python parser.py

echo.
echo ==========================================
echo      Execution finished
echo ==========================================
exit /b 0