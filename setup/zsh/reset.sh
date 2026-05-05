#!/bin/bash
set -euo pipefail

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../.. && pwd)
SETUP_DIR_RELATIVE=$REPO_ROOT/setup

echo -e "Setting up dotfiles and environment"

source "$SETUP_DIR_RELATIVE/constants.sh"

function_files_to_load=()
function_files_to_load+=("$REPO_BASH_BIN_DIR/file_system.sh")

# Source files needed by the script
for file in "${function_files_to_load[@]}"; do
    if [[ -f ${file} ]]; then
        source "$file"
    fi
done
unset file

echo "Reset dotfiles and environment to original state"

echo "Removing symlinks"

remove_symlinks_of_source_file "$ZSH_ZSHRC_FILE"
remove_symlinks_of_source_file "$ZSH_EXPORTS_FILE"
remove_symlinks_of_source_file "$ZSH_OPTIONS_FILE"
remove_symlinks_of_source_file "$ZSH_PLUGINS_FILE"
remove_symlinks_of_source_file "$ZSH_MACOS_FILE"

echo "Removing directories if they are empty"

echo "Done Resetting! Please run 'zsh -l' in the bash shell to apply changes"

