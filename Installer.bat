@echo off
title KetZipper Installer
setlocal EnableDelayedExpansion

echo Installing KetZipper...
set INSTALL_DIR=C:\KetZipper

:: Create install directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Download extractor.py
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('YOUR_EXTRACTOR_PY_URL', '%INSTALL_DIR%\extractor.py')"

:: Download UnRar.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('YOUR_UNRAR_EXE_URL', '%INSTALL_DIR%\UnRar.exe')"

:: Install Python dependencies
python -m pip install tk rarfile

:: Add context menu entry for right-click
reg add "HKEY_CLASSES_ROOT\*\shell\KetZipper" /ve /d "Extract with KetZipper" /f
reg add "HKEY_CLASSES_ROOT\*\shell\KetZipper\command" /ve /d "\"C:\KetZipper\extractor.py\" \"%%1\"" /f

echo KetZipper installed successfully!
pause
