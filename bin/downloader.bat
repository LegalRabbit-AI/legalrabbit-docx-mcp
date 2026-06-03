@echo off
setlocal enabledelayedexpansion

:: Define the JSON file name
set "JSON_FILE=%~dp0\..\.claude-plugin\plugin.json"

:: Check if the file exists
if not exist "%JSON_FILE%" (
    echo Error: %JSON_FILE% not found.
    exit /b 1
)

:: Loop through the file to find the version line
for /f "tokens=1,2 delims=:" %%a in ('findstr /i "\"version\"" "%JSON_FILE%"') do (
    :: %%b contains the value (e.g., "0.2.0",)
    set "VERSION=%%b"
    
    :: Strip spaces, quotes, and commas
    set "VERSION=!VERSION: =!"
    set "VERSION=!VERSION:"=!"
    set "VERSION=!VERSION:,=!"
)

echo The version is: %VERSION% 1>&2

curl -R -L -s -z "%~dp0\legalrabbit-docx-mcp.exe" -o "%~dp0\legalrabbit-docx-mcp.exe.tmp" "https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/%VERSION%/legalrabbit-docx-mcp.exe"

if %ERRORLEVEL% EQU 0 (
    if exist "%~dp0\legalrabbit-docx-mcp.exe.tmp" move /Y "%~dp0\legalrabbit-docx-mcp.exe.tmp" "%~dp0\legalrabbit-docx-mcp.exe" >nul
    echo Download successful! 1>&2
) else (
    echo Download failed with error code: %ERRORLEVEL% 1>&2
    exit /b 1
)

set "APP_VERSION=%VERSION%"

%~dp0\legalrabbit-docx-mcp.exe