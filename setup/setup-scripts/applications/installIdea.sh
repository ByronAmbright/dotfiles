#!/bin/bash
set -euo pipefail

# ============================================================================
# IntelliJ IDEA Installation Script
#
# Downloads and installs IntelliJ IDEA Community Edition on Linux systems.
# Requires sudo access. Places installation in /opt/idea.
# ============================================================================

echo "Installing Intellij Idea"

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
SETUP_DIR_RELATIVE="$REPO_ROOT/setup"

source "$SETUP_DIR_RELATIVE/constants.sh"

function_files_to_load=()
function_files_to_load+=("$REPO_BASH_BIN_DIR/network.sh")
function_files_to_load+=("$REPO_BASH_BIN_DIR/os.sh")

# Source files needed by the script
for file in "${function_files_to_load[@]}"; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done
unset file

if ! shopt -oq posix; then
    if [[ ! "$(osname_linux)" == "Unknown" ]]; then
        local_intellj_download_path=""

        cleanup() {
            if [[ -n "${local_intellj_download_path}" && -f "${local_intellj_download_path}" ]]; then
                echo "Cleaning up download file..."
                sudo rm -f "${local_intellj_download_path}"
            fi
        }
        trap cleanup EXIT INT TERM

        INTELLJ_VERSION_AND_NAME="ideaIC-2024.1.4.tar.gz"
        INTELLJ_IDEA_DOWNLOAD_URL="https://download.jetbrains.com/idea/$INTELLJ_VERSION_AND_NAME"
        INTELLJ_IDEA_DOWNLOAD_PATH="$OPT_FOLDER/$INTELLJ_VERSION_AND_NAME"
        local_intellj_download_path="$INTELLJ_IDEA_DOWNLOAD_PATH"

        download_file_if_it_does_not_exist_already "$INTELLJ_IDEA_RUN_SCRIPT" "$INTELLJ_IDEA_DOWNLOAD_PATH" "$INTELLJ_IDEA_DOWNLOAD_URL"
        if [[ -f "$INTELLJ_IDEA_DOWNLOAD_PATH" ]]; then
            sudo tar -xzf "$INTELLJ_IDEA_DOWNLOAD_PATH" -C "$OPT_FOLDER"
            sudo rm -rf "$INTELLJ_IDEA_DOWNLOAD_PATH"
            local_intellj_download_path=""
            sudo mv "$OPT_FOLDER"/idea-* "$INTELLJ_IDEA_INSTALL_FOLDER"
        fi
    fi
fi