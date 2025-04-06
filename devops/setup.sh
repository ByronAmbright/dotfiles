#!/bin/bash -eu

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

echo -e "Setting up dotfiles and environment"

source $DEVOPS_DIR/constants.sh

echo -e "\nCreating directories"
mkdir -p $CONFIG_DIR
mkdir -p $GIT_CONFIG_DIR

sudo mkdir -p $INTELLJ_IDEA_INSTALL_FOLDER
sudo mkdir -p $PYCHARM_INSTALL_FOLDER

echo -e "\nDownloading dependencies if necessary"

# Check to see if git completion scripts need to be downloaded
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installPackages.sh
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installGitCompletion.sh
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installDocker.sh
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installNodejs.sh
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installRipgrep.sh

echo -e "\n\nDownloading and installing applications"

$APPLICATION_SETUP_SCRIPTS_DIR/installIdea.sh
$APPLICATION_SETUP_SCRIPTS_DIR/installPycharm.sh
$APPLICATION_SETUP_SCRIPTS_DIR/installVSCode.sh

source $REPO_BASH_DIR/.functions

echo -e "\nResetting previous dotfiles repo specific if there is any"

. $DEVOPS_DIR/reset.sh

echo -e "\n\nCreating symlinks"

symlink_or_symlink_as_alt_name_as_necessary "$BASH_BASHRC_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_INPUTRC_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_PROMPT_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_ALIASES_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_FUNCTIONS_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_EXPORTS_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_PATH_FILE" "$HOME"

symlink_or_symlink_as_alt_name_as_necessary "$ZSH_ZSHRC_FILE" "$HOME"

symlink_or_symlink_as_alt_name_as_necessary "$XRESOURCES_RESOURCE_FILE" "$HOME"

symlink_or_symlink_as_alt_name_as_necessary "$DIRCOLORS_CONFIG_FILE" "$CONFIG_DIR"
symlink_or_symlink_as_alt_name_as_necessary "$RIPGREP_CONFIG_FILE" "$CONFIG_DIR"
symlink_or_symlink_as_alt_name_as_necessary "$GIT_CONFIG_FOLDER" "$GIT_CONFIG_DIR"

create_symlink_if_necessary "$INTELLJ_IDEA_RUN_SCRIPT" "$INTELLJ_IDEA_USR_LOCAL_BIN"
create_symlink_if_necessary "$PYCHARM_RUN_SCRIPT" "$PYCHARM_USR_LOCAL_BIN"
create_symlink_if_necessary "$RIPGREP_RUN_SCRIPT" "$RIPGREP_USR_LOCAL_BIN"

create_symlink_if_necessary "$BASH_BASHRC_SECRET_FILE" "$BASH_BASHRC_SECRET_FILE_TARGET_LOCATION"
create_symlink_if_necessary "$BASH_PATH_SECRET_FILE" "$BASH_PATH_SECRET_FILE_TARGET_LOCATION"

echo -e "\n\nDone! Please run 'bash -l' in the bash shell to apply changes"
