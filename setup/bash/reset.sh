#!/bin/bash
set -euo pipefail

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../.. && pwd)
SETUP_DIR_RELATIVE=$REPO_ROOT/setup

echo "Resetting dotfiles and environment to original state"

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


echo "Removing symlinks"

remove_symlinks_of_source_file "$BASH_BASHRC_FILE"
remove_symlinks_of_source_file "$BASH_INPUTRC_FILE"
remove_symlinks_of_source_file "$BASH_PROMPT_FILE"
remove_symlinks_of_source_file "$BASH_ALIASES_FILE"
remove_symlinks_of_source_file "$BASH_EXPORTS_FILE"
remove_symlinks_of_source_file "$BASH_PATH_FILE"
remove_symlinks_of_source_file "$BASH_LIBRARY_FILE"

remove_symlinks_of_source_file "$XRESOURCES_RESOURCE_FILE"
remove_symlinks_of_source_file "$DIRCOLORS_CONFIG_FILE" "$CONFIG_DIR"
remove_symlinks_of_source_file "$RIPGREP_CONFIG_FILE" "$CONFIG_DIR"
remove_symlinks_of_source_file "$GIT_CONFIG_FILE" "$GIT_CONFIG_DIR"
remove_symlinks_of_source_file "$TAILSPIN_CONFIG_FOLDER" "$TAILSPING_CONFIG_DIR"

remove_symlinks_of_source_file "$INTELLJ_IDEA_RUN_SCRIPT" "$USR_LOCAL_BIN"
remove_symlinks_of_source_file "$PYCHARM_RUN_SCRIPT" "$USR_LOCAL_BIN"
remove_symlinks_of_source_file "$RIPGREP_RUN_SCRIPT" "$USR_LOCAL_BIN"

echo "Removing directories if they are empty"

rm -d "$GIT_CONFIG_DIR" || true

echo "Done Resetting! Please run 'bash -l' in the bash shell to apply changes"

