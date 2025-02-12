@echo off
title KetZipper Installer
setlocal EnableDelayedExpansion

echo Installing KetZipper...
set INSTALL_DIR="C:\KetZipper"

:: Create install directory if it doesn't exist
if not exist %INSTALL_DIR% mkdir %INSTALL_DIR%

:: Download extractor.py
echo Downloading extractor.py...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/reganktn/ketzipper/raw/refs/heads/main/extractor.py', '%INSTALL_DIR%\extractor.py')" || (echo Failed to download extractor.py & pause & exit /b)

:: Download UnRar.exe for extracting RAR files
echo Downloading UnRar.exe...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/reganktn/ketzipper/raw/refs/heads/main/UnRAR.exe', '%INSTALL_DIR%\UnRar.exe')" || (echo Failed to download UnRar.exe & pause & exit /b)

:: Download zipper.py for creating archives
echo Downloading zipper.py...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/reganktn/ketzipper/raw/refs/heads/main/zipper.py', '%INSTALL_DIR%\zipper.py')" || (echo Failed to download zipper.py & pause & exit /b)

:: Download Rar.exe for creating RAR files
echo Downloading Rar.exe...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/reganktn/ketzipper/raw/refs/heads/main/Rar.exe', '%INSTALL_DIR%\Rar.exe')" || (echo Failed to download Rar.exe & pause & exit /b)

:: Find Python executable path automatically
for /f "delims=" %%i in ('where python') do (
    set PYTHON_PATH=%%i
    if not defined FOUND_PYTHON (
        set FOUND_PYTHON=1
        goto :found_python
    )
)

:found_python

:: Check if Python was found
if "%PYTHON_PATH%"=="" (
    echo Python is not installed or not added to the system path. Please install Python first.
    pause
    exit /b
)

:: Check if the Python path is from the Microsoft Store and adjust
echo Checking for Python version...
if /I "%PYTHON_PATH%"=="C:\Users\Ixchel\AppData\Local\Microsoft\WindowsApps\python.exe" (
    echo Found Microsoft Store Python, using the other version...
    set PYTHON_PATH=C:\Python313\python.exe
)

:: Install Python dependencies
echo Installing Python dependencies...
"%PYTHON_PATH%" -m pip install tk rarfile || (echo Failed to install dependencies & pause & exit /b)

:: Add "KetZipper" main context menu
echo Adding KetZipper to context menu...
reg add "HKEY_CLASSES_ROOT\*\shell\KetExtractor" /ve /d "KetExtractor (Extract)" /f
reg add "HKEY_CLASSES_ROOT\*\shell\KetExtractor\command" /ve /d "\"%PYTHON_PATH%\" \"C:\KetZipper\extractor.py\" \"%%1\"" /f

reg add "HKEY_CLASSES_ROOT\*\shell\KetZipper" /ve /d "KetZipper (Create Archive)" /f
reg add "HKEY_CLASSES_ROOT\*\shell\KetZipper\command" /ve /d "\"%PYTHON_PATH%\" \"C:\KetZipper\zipper.py\" \"%%1\"" /f

reg add "HKEY_CLASSES_ROOT\Directory\shell\KetExtractor" /ve /d "KetExtractor (Extract)" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\KetExtractor\command" /ve /d "\"%PYTHON_PATH%\" \"C:\KetZipper\extractor.py\" \"%%1\"" /f

reg add "HKEY_CLASSES_ROOT\Directory\shell\KetZipper" /ve /d "KetZipper (Create Archive)" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\KetZipper\command" /ve /d "\"%PYTHON_PATH%\" \"C:\KetZipper\zipper.py\" \"%%1\"" /f

echo KetZipper installed successfully!
pause
