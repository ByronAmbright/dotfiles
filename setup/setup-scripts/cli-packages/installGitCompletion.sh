#!/bin/bash
set -euo pipefail

# ============================================================================
# Git Completion Installation Script
#
# Downloads git-prompt.sh and git-completion.bash from the official git repo
# if they are not already present locally.
# ============================================================================

echo "Installing Git Completion"

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
    GIT_COMPLETION_DOWNLOAD_URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/"
    LOCAL_GIT_CORE_COMPLETION_FOLDER="/usr/local/share/git-core/contrib/completion"

    download_file_if_it_does_not_exist_already "$LOCAL_GIT_CORE_COMPLETION_FOLDER/git-prompt.sh" "$GIT_CONFIG_DIR/.git-prompt.sh" "$GIT_COMPLETION_DOWNLOAD_URL/git-prompt.sh"
    download_file_if_it_does_not_exist_already "$LOCAL_GIT_CORE_COMPLETION_FOLDER/git-completion.bash" "$GIT_CONFIG_DIR/.git-completion.bash" "$GIT_COMPLETION_DOWNLOAD_URL/git-completion.bash"
fi
