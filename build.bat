@echo off
setlocal enabledelayedexpansion
echo ============================================
echo   Persona Asset Forge - Build Script
echo ============================================
echo.

:: Check Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found in PATH.
    echo Install Python 3.10+ from https://www.python.org
    pause
    exit /b 1
)
echo Python found:
python --version
echo.

:: Install / update dependencies
echo Installing dependencies...
python -m pip install --upgrade pip --quiet
python -m pip install pillow customtkinter darkdetect pyinstaller --quiet
if errorlevel 1 (
    echo ERROR: pip install failed. Check your internet connection.
    pause
    exit /b 1
)
echo Done.
echo.

:: Clean previous build artifacts
echo Cleaning previous build...
if exist dist   rmdir /s /q dist
if exist build  rmdir /s /q build
echo Done.
echo.

:: -------------------------------------------------------
:: Step 1: Build portable EXE with PyInstaller
:: -------------------------------------------------------
echo [1/2] Building PersonaAssetForge.exe...
echo.
python -m PyInstaller bg_remover.spec
if errorlevel 1 (
    echo.
    echo ERROR: PyInstaller build failed.
    pause
    exit /b 1
)
if not exist "dist\PersonaAssetForge.exe" (
    echo ERROR: EXE not found after build.
    pause
    exit /b 1
)
for %%A in ("dist\PersonaAssetForge.exe") do set /a EXE_MB=%%~zA / 1048576
echo.
echo   [OK] dist\PersonaAssetForge.exe (!EXE_MB! MB)
echo.

:: -------------------------------------------------------
:: Step 2: Build installer with Inno Setup
:: -------------------------------------------------------
echo [2/2] Building installer with Inno Setup...

:: Search common Inno Setup install locations
set ISCC=
for %%P in (
    "%ProgramFiles(x86)%\Inno Setup 6\iscc.exe"
    "%ProgramFiles%\Inno Setup 6\iscc.exe"
    "%ProgramFiles(x86)%\Inno Setup 5\iscc.exe"
    "%ProgramFiles%\Inno Setup 5\iscc.exe"
) do (
    if exist %%P set ISCC=%%P
)

if "%ISCC%"=="" (
    echo.
    echo   [SKIP] Inno Setup not found - installer not built.
    echo          Download from https://jrsoftware.org/isinfo.php to enable.
    echo          The portable EXE above is still ready to use.
    goto :report
)

echo   Using: %ISCC%
%ISCC% installer.iss
if errorlevel 1 (
    echo.
    echo ERROR: Inno Setup build failed.
    pause
    exit /b 1
)
for %%A in ("dist\PersonaAssetForge_Setup.exe") do set /a INS_MB=%%~zA / 1048576
echo.
echo   [OK] dist\PersonaAssetForge_Setup.exe (!INS_MB! MB)

:report
echo.
echo ============================================
echo   BUILD COMPLETE
echo ============================================
echo.
echo   Portable  : dist\PersonaAssetForge.exe
if exist "dist\PersonaAssetForge_Setup.exe" (
    echo   Installer : dist\PersonaAssetForge_Setup.exe
)
echo.
echo Upload both to GitHub Releases, or just run the EXE directly.
echo.
pause
