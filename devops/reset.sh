#!/bin/bash -eu

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

# Include functions and other constants
source $DEVOPS_DIR/constants.sh
source $REPO_BASH_DIR/.functions

echo "Reset dotfiles and environment to original state"

echo "Removing symlinks"

remove_symlinks_of_source_file "$BASH_BASHRC_FILE"
remove_symlinks_of_source_file "$BASH_INPUTRC_FILE"
remove_symlinks_of_source_file "$BASH_PROMPT_FILE"
remove_symlinks_of_source_file "$BASH_ALIASES_FILE"
remove_symlinks_of_source_file "$BASH_FUNCTIONS_FILE"
remove_symlinks_of_source_file "$BASH_EXPORTS_FILE"
remove_symlinks_of_source_file "$BASH_PATH_FILE"

remove_symlinks_of_source_file "$ZSH_ZSHRC_FILE"

remove_symlinks_of_source_file "$XRESOURCES_RESOURCE_FILE"
remove_symlinks_of_source_file "$DIRCOLORS_CONFIG_FILE" "$CONFIG_DIR"
remove_symlinks_of_source_file "$RIPGREP_CONFIG_FILE" "$CONFIG_DIR"
remove_symlinks_of_source_file "$GIT_CONFIG_FOLDER" "$GIT_CONFIG_DIR"

remove_symlinks_of_source_file "$INTELLJ_IDEA_RUN_SCRIPT" "$USR_LOCAL_BIN"
remove_symlinks_of_source_file "$PYCHARM_RUN_SCRIPT" "$USR_LOCAL_BIN"
remove_symlinks_of_source_file "$RIPGREP_RUN_SCRIPT" "$USR_LOCAL_BIN"

remove_symlinks_of_source_file "$BASH_BASHRC_SECRET_FILE"
remove_symlinks_of_source_file "$BASH_PATH_SECRET_FILE"

echo "Removing directories if they are empty"

rm -d $GIT_CONFIG_DIR || true

echo "Done Resetting! Please run 'bash -l' in the bash shell to apply changes"

