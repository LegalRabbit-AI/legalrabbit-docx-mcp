@echo off
setlocal enabledelayedexpansion

set "INTERNAL_VERSION=0.5.0-dev"

set "PLUGIN_DIR=%~dp0.."

set "ZIP_FILE_PATH=%PLUGIN_DIR%\legalrabbit-docx.manifest"

if exist "%ZIP_FILE_PATH%" (
    for %%A in ("%ZIP_FILE_PATH%") do (
        if %%~zA LSS 1024 (
            del /q "%ZIP_FILE_PATH%" 2>nul
        )
    )
)

curl -R -L -s -z "%ZIP_FILE_PATH%" -o "%ZIP_FILE_PATH%" "https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/%INTERNAL_VERSION%/legalrabbit-docx.manifest"

if %ERRORLEVEL% EQU 0 (
    echo Downloaded %ZIP_FILE_PATH% successful! 1>&2
) else (
    if exist "%ZIP_FILE_PATH%" del /q "%ZIP_FILE_PATH%" 2>nul
    echo Downloading %ZIP_FILE_PATH% failed with error code: %ERRORLEVEL% 1>&2
    exit /b 1
)

if exist "%PLUGIN_DIR%\agents" (
    rmdir /s /q "%PLUGIN_DIR%\agents"
)

if exist "%PLUGIN_DIR%\skills" (
    rmdir /s /q "%PLUGIN_DIR%\skills"
)

tar -xf "%ZIP_FILE_PATH%" -C "%PLUGIN_DIR%"

if not exist "%PLUGIN_DIR%\bin" (
    mkdir "%PLUGIN_DIR%\bin"
)

set "MCP_EXECUTABLE_PATH=%PLUGIN_DIR%\bin\legalrabbit-docx-mcp.exe"

if exist "%MCP_EXECUTABLE_PATH%" (
    for %%A in ("%MCP_EXECUTABLE_PATH%") do (
        if %%~zA LSS 1024 (
            del /q "%MCP_EXECUTABLE_PATH%" 2>nul
        )
    )
)

curl -R -L -s -z "%MCP_EXECUTABLE_PATH%" -o "%MCP_EXECUTABLE_PATH%" "https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/%INTERNAL_VERSION%/legalrabbit-docx-mcp.exe"

if %ERRORLEVEL% EQU 0 (
    echo Downloaded %MCP_EXECUTABLE_PATH% successful! 1>&2
) else (
    del /q "%MCP_EXECUTABLE_PATH%" 2>nul
    echo Downloading %MCP_EXECUTABLE_PATH% failed with error code: %ERRORLEVEL% 1>&2
    exit /b 1
)

:: Define the JSON file name
set "JSON_FILE=%PLUGIN_DIR%\.claude-plugin\plugin.json"

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

set "APP_VERSION=%VERSION%"

%PLUGIN_DIR%\bin\legalrabbit-docx-mcp.exe
