#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read version from plugin.json
VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "${SCRIPT_DIR}/../.claude-plugin/plugin.json" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

FILEPATH="${SCRIPT_DIR}/legalrabbit-docx-mcp"

if [ ! -f "${FILEPATH}" ]; then
    # Download the file to the script's directory
    DOWNLOAD_URL="https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/${VERSION}/legalrabbit-docx-mcp"
    if ! curl -R -s -L -z "${FILEPATH}" -o "${FILEPATH}" "${DOWNLOAD_URL}"; then
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


export APP_VERSION="${VERSION}"  

exec "${FILEPATH}" <&0
