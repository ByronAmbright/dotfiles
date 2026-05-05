#!/bin/bash
set -euo pipefail

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../.. && pwd)
SETUP_DIR_RELATIVE=$REPO_ROOT/setup

echo -e "Setting up dotfiles and environment"

source "$SETUP_DIR_RELATIVE/constants.sh"

function_files_to_load=()
function_files_to_load+=("$REPO_BASH_BIN_DIR/os.sh")

# Source files needed by the script
for file in "${function_files_to_load[@]}"; do
    if [[ -f ${file} ]]; then
        source "$file"
    fi
done
unset file


echo -e "Setting up dotfiles and environment"

echo -e "\nRunning Bash Setup First"

. "$SETUP_BASH_DIR/setup.sh"

echo -e "\nDone running Bash setup"


echo -e "\nRunning Macos Specific Setup"

if [[ "$(osname)" == "MacOSX" ]]; then
    $OS_SETUP_SCRIPTS_DIR/setupMacOS.sh
fi

echo -e "\nResetting previous dotfiles repo specific files if there is any"

. "$SETUP_ZSH_DIR/reset.sh"

echo -e "\n\nCreating symlinks"

symlink_or_symlink_as_alt_name_as_necessary "$ZSH_ZSHRC_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$ZSH_EXPORTS_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$ZSH_OPTIONS_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$ZSH_PLUGINS_FILE" "$HOME"
if [[ "$(osname)" == "MacOSX" ]]; then
    symlink_or_symlink_as_alt_name_as_necessary "$ZSH_MACOS_FILE" "$HOME"
fi

echo -e "\n\nDone! Please run 'zsh -l' in the zsh shell to apply changes"
