#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read version from plugin.json
VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "${SCRIPT_DIR}/../.claude-plugin/plugin.json" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Detect if running on Windows
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    EXE_EXT=".exe"
else
    EXE_EXT=""
fi

FILEPATH="${SCRIPT_DIR}/legalrabbit-docx-mcp-${VERSION}${EXE_EXT}"

# Delete other versions
find "${SCRIPT_DIR}" -maxdepth 1 -name "legalrabbit-docx-mcp-*" ! -name "legalrabbit-docx-mcp-${VERSION}${EXE_EXT}" -type f -delete 2>/dev/null

if [ ! -f "${FILEPATH}" ]; then
    # Download the file to the script's directory
    DOWNLOAD_URL="https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/${VERSION}/legalrabbit-docx-mcp${EXE_EXT}"
    if ! curl -s -L -o "${FILEPATH}" "${DOWNLOAD_URL}"; then
        rm -f "${FILEPATH}"
        echo "Error: Failed to download the LegalRabbit executable from ${DOWNLOAD_URL}" >&2
        exit 1
    fi

    # Make the downloaded file executable
    chmod +x "${FILEPATH}"

    echo "Download completed: ${FILEPATH}" >&2
else
    echo "File already exists, skipping download: ${FILEPATH}" >&2
fi


export APP_VERSION="${VERSION}" && export CLAUDE_PLUGIN_DATA="${CLAUDE_PLUGIN_DATA}" && exec "${FILEPATH}" <&0
