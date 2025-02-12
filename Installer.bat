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

:: Download UnRar.exe
echo Downloading UnRar.exe...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/reganktn/ketzipper/raw/refs/heads/main/UnRAR.exe', '%INSTALL_DIR%\UnRar.exe')" || (echo Failed to download UnRar.exe & pause & exit /b)

:: Download zipper.py for creating archives
echo Downloading zipper.py...
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://github.com/reganktn/ketzipper/raw/refs/heads/main/zipper.py', '%INSTALL_DIR%\zipper.py')" || (echo Failed to download zipper.py & pause & exit /b)

:: Install Python dependencies
echo Installing Python dependencies...
python -m pip install tk rarfile zipfile || (echo Failed to install dependencies & pause & exit /b)

:: Add context menu entry for .zip files
echo Adding context menu entry for .zip files...
reg add "HKEY_CLASSES_ROOT\.zip\shell\KetZipper" /ve /d "Extract with KetZipper" /f
reg add "HKEY_CLASSES_ROOT\.zip\shell\KetZipper\command" /ve /d "\"C:\KetZipper\extractor.py\" \"%%1\"" /f

:: Add context menu entry for .rar files
echo Adding context menu entry for .rar files...
reg add "HKEY_CLASSES_ROOT\.rar\shell\KetZipper" /ve /d "Extract with KetZipper" /f
reg add "HKEY_CLASSES_ROOT\.rar\shell\KetZipper\command" /ve /d "\"C:\KetZipper\extractor.py\" \"%%1\"" /f

:: Add context menu entry for creating an archive
echo Adding context menu entry for Create Archive...
reg add "HKEY_CLASSES_ROOT\*\shell\CreateArchive" /ve /d "Create archive with KetZipper" /f
reg add "HKEY_CLASSES_ROOT\*\shell\CreateArchive\command" /ve /d "\"C:\KetZipper\zipper.py\" \"%%1\"" /f

:: Add context menu entry for directories
echo Adding context menu entry for folders...
reg add "HKEY_CLASSES_ROOT\Directory\shell\CreateArchive" /ve /d "Create archive with KetZipper" /f
reg add "HKEY_CLASSES_ROOT\Directory\shell\CreateArchive\command" /ve /d "\"C:\KetZipper\zipper.py\" \"%%1\"" /f

echo KetZipper installed successfully!
pause
