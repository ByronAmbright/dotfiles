#!/bin/bash
set -euo pipefail

# ============================================================================
# Ripgrep Installation Script
#
# Downloads and installs ripgrep on Linux systems from the GitHub releases
# page. Requires sudo access. Places installation in /opt/ripgrep.
# ============================================================================

echo "Installing Ripgrep"

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

# Potentially change to getting latest instead of specific version
# URL="$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r ".assets[] | select(.name | endswith(\"-x86_64-unknown-linux-musl.tar.gz\")) | .browser_download_url")"
# Generic function to retrieve the latest release URL from a GitHub repository
# get_latest_release_url_from_repo() {
#     local owner="$1"
#     local repo="$2"
#     local os_type="$3"
#     local asset_arch="$4"

#     local latest_release_url=$(curl -s "https://api.github.com/repos/${owner}/${repo}/releases/latest" | \
#         jq -r --arg asset_arch "$asset_arch" --arg os_type "$os_type" \
#         '.assets[] | select(.name | contains($asset_arch) and contains($os_type)) | .browser_download_url' | head -1)

#     if [[ -z "$latest_release_url" ]]; then
#         echo "Error: Could not find a download URL for ${os_type}-${asset_arch}."
#         return 1
#     fi

#     echo "$latest_release_url"
# }

if ! shopt -oq posix; then
    if [[ ! "$(osname_linux)" == "Unknown" ]]; then
        local_ripgrep_download_path=""

        cleanup() {
            if [[ -n "${local_ripgrep_download_path}" && -f "${local_ripgrep_download_path}" ]]; then
                echo "Cleaning up download file..."
                sudo rm -f "${local_ripgrep_download_path}"
            fi
        }
        trap cleanup EXIT INT TERM

        RIPGREP_VERSION="14.1.1"
        RIPGREP_VERSION_AND_NAME="ripgrep-$RIPGREP_VERSION-x86_64-unknown-linux-musl.tar.gz"
        RIPGREP_DOWNLOAD_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VERSION/$RIPGREP_VERSION_AND_NAME"
        RIPGREP_DOWNLOAD_PATH="$OPT_FOLDER/$RIPGREP_VERSION_AND_NAME"
        local_ripgrep_download_path="$RIPGREP_DOWNLOAD_PATH"

        download_file_if_it_does_not_exist_already "$RIPGREP_RUN_SCRIPT" "$RIPGREP_DOWNLOAD_PATH" "$RIPGREP_DOWNLOAD_URL"
        if [[ -f "$RIPGREP_DOWNLOAD_PATH" ]]; then
            sudo tar -xzf "$RIPGREP_DOWNLOAD_PATH" -C "$OPT_FOLDER"
            sudo rm -rf "$RIPGREP_DOWNLOAD_PATH"
            local_ripgrep_download_path=""
            sudo mv "$OPT_FOLDER"/ripgrep-* "$RIPGREP_INSTALL_FOLDER"
        fi
    fi
fi