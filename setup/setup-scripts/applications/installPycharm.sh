#!/bin/bash
set -euo pipefail

# ============================================================================
# PyCharm Installation Script
#
# Downloads and installs PyCharm Community Edition on Linux systems.
# Requires sudo access. Places installation in /opt/pycharm.
# ============================================================================

echo "Installing Intellij PyCharm"

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
        local_pycharm_download_path=""

        cleanup() {
            if [[ -n "${local_pycharm_download_path}" && -f "${local_pycharm_download_path}" ]]; then
                echo "Cleaning up download file..."
                sudo rm -f "${local_pycharm_download_path}"
            fi
        }
        trap cleanup EXIT INT TERM

        PYCHARM_VERSION_AND_NAME="pycharm-community-2024.2.3.tar.gz"
        PYCHARM_DOWNLOAD_URL="https://download.jetbrains.com/python/$PYCHARM_VERSION_AND_NAME"
        PYCHARM_DOWNLOAD_PATH="$OPT_FOLDER/$PYCHARM_VERSION_AND_NAME"
        local_pycharm_download_path="$PYCHARM_DOWNLOAD_PATH"

        download_file_if_it_does_not_exist_already "$PYCHARM_RUN_SCRIPT" "$PYCHARM_DOWNLOAD_PATH" "$PYCHARM_DOWNLOAD_URL"
        if [[ -f "$PYCHARM_DOWNLOAD_PATH" ]]; then
            sudo tar -xzf "$PYCHARM_DOWNLOAD_PATH" -C "$OPT_FOLDER"
            sudo rm -rf "$PYCHARM_DOWNLOAD_PATH"
            local_pycharm_download_path=""
            sudo mv "$OPT_FOLDER"/pycharm-* "$PYCHARM_INSTALL_FOLDER"
        fi
    fi
fi