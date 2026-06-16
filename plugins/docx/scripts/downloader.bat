@echo off
setlocal enabledelayedexpansion

for /f "delims=" %%I in ("%~dp0..") do set "PLUGIN_FULL_LONG_DIR=%%~fI"

for %%I in ("%PLUGIN_FULL_LONG_DIR%") do set "PLUGIN_DIR=%%~sI"

echo The plugin dir is: %PLUGIN_FULL_LONG_DIR% 1>&2
echo The plugin short dir is: %PLUGIN_DIR% 1>&2

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

set "ZIP_FILE_PATH=%PLUGIN_DIR%\legalrabbit-docx.manifest"

if exist "%ZIP_FILE_PATH%" (
    for %%A in ("%ZIP_FILE_PATH%") do (
        if %%~zA LSS 1024 (
            del /q "%ZIP_FILE_PATH%" 2>nul
        )
    )
)

curl -R -L -s -f -z "%ZIP_FILE_PATH%" -o "%ZIP_FILE_PATH%.tmp" "https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/%APP_VERSION%/legalrabbit-docx.manifest"

if %ERRORLEVEL% EQU 0 (
    if exist "%ZIP_FILE_PATH%.tmp" (
        move /y "%ZIP_FILE_PATH%.tmp" "%ZIP_FILE_PATH%" >nul
        echo Downloaded %ZIP_FILE_PATH% successfully. 1>&2
    ) else (
        echo The current legalrabbit-docx.manifest is up-to-date. 1>&2
    )
) else (
    if not exist "%ZIP_FILE_PATH%" (
        echo Downloading %ZIP_FILE_PATH% failed with error code: %ERRORLEVEL% 1>&2
        exit /b 1
    )
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

curl -R -L -s -f -z "%MCP_EXECUTABLE_PATH%" -o "%MCP_EXECUTABLE_PATH%.tmp" "https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/%APP_VERSION%/legalrabbit-docx-mcp.exe"

if %ERRORLEVEL% EQU 0 (
    if exist "%MCP_EXECUTABLE_PATH%.tmp" (
        move /y "%MCP_EXECUTABLE_PATH%.tmp" "%MCP_EXECUTABLE_PATH%" >nul
        echo Downloaded %MCP_EXECUTABLE_PATH% successfully. 1>&2
    ) else (
        echo The current legalrabbit-docx-mcp.exe is up-to-date. 1>&2
    )
) else (
    if not exist "%MCP_EXECUTABLE_PATH%" (
        echo Downloading %MCP_EXECUTABLE_PATH% failed with error code: %ERRORLEVEL% 1>&2
        exit /b 1
    )
)


"%PLUGIN_DIR%\bin\legalrabbit-docx-mcp.exe"
