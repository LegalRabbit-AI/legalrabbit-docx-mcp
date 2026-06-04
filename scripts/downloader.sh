#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INTERNAL_VERSION="0.5.0-dev"
PLUGIN_DIR="$(realpath "${SCRIPT_DIR}/..")"
MCP_EXECUTABLE_FILEPATH="${PLUGIN_DIR}/bin/legalrabbit-docx-mcp"

if [ "${LEGALRABBIT_DOCX_TEST_MODE}" != "true" ]; then
  ZIP_FILEPATH="${PLUGIN_DIR}/legalrabbit-docx.manifest"

  if [ -f "${ZIP_FILEPATH}" ] && [ $(stat -f%z "${ZIP_FILEPATH}" 2>/dev/null || stat -c%s "${ZIP_FILEPATH}" 2>/dev/null) -lt 1024 ]; then
      rm -f "${ZIP_FILEPATH}"
  fi

  DOWNLOAD_URL="https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/${INTERNAL_VERSION}/legalrabbit-docx.manifest"
  if ! curl -R -s -L -z "${ZIP_FILEPATH}" -o "${ZIP_FILEPATH}" "${DOWNLOAD_URL}"; then
      rm -f "${ZIP_FILEPATH}"
      echo "Error: Failed to download the LegalRabbit executable from ${DOWNLOAD_URL}" >&2
      exit 1
  fi

  rm -rf "${PLUGIN_DIR}/agents"
  rm -rf "${PLUGIN_DIR}/skills"
  UNZIP -d "${PLUGIN_DIR}" "${ZIP_FILEPATH}"

  mkdir -p "${PLUGIN_DIR}/bin"

  if [ -f "${MCP_EXECUTABLE_FILEPATH}" ] && [ $(stat -f%z "${MCP_EXECUTABLE_FILEPATH}" 2>/dev/null || stat -c%s "${MCP_EXECUTABLE_FILEPATH}" 2>/dev/null) -lt 1024 ]; then
      rm -f "${MCP_EXECUTABLE_FILEPATH}"
  fi

  DOWNLOAD_URL="https://github.com/LegalRabbit-AI/legalrabbit-docx-claude-plugin/releases/download/${INTERNAL_VERSION}/legalrabbit-docx-mcp"
  if ! curl -R -s -L -z "${MCP_EXECUTABLE_FILEPATH}" -o "${MCP_EXECUTABLE_FILEPATH}" "${DOWNLOAD_URL}"; then
      rm -f "${MCP_EXECUTABLE_FILEPATH}"
      echo "Error: Failed to download the LegalRabbit executable from ${DOWNLOAD_URL}" >&2
      exit 1
  fi

  chmod +x "${MCP_EXECUTABLE_FILEPATH}"
fi

# Read version from plugin.json
VERSION=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "${PLUGIN_DIR}/.claude-plugin/plugin.json" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
export APP_VERSION="${VERSION}"

exec "${MCP_EXECUTABLE_FILEPATH}" <&0
