#!/bin/bash
set -euo pipefail

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../.. && pwd)
SETUP_DIR_RELATIVE=$REPO_ROOT/setup

echo -e "Setting up dotfiles and environment"

source "$SETUP_DIR_RELATIVE/constants.sh"

function_files_to_load=()
function_files_to_load+=("$REPO_BASH_BIN_DIR/file_system.sh")
function_files_to_load+=("$REPO_BASH_BIN_DIR/os.sh")

# Source files needed by the script
for file in "${function_files_to_load[@]}"; do
    if [[ -f ${file} ]]; then
        source "$file"
    fi
done
unset file

echo -e "\nCreating directories"
mkdir -p "$CONFIG_DIR"
mkdir -p "$GIT_CONFIG_DIR"
mkdir -p "$HOME_BIN"


sudo mkdir -p "$INTELLJ_IDEA_INSTALL_FOLDER"
sudo mkdir -p "$PYCHARM_INSTALL_FOLDER"

echo -e "\nDownloading dependencies if necessary"

# Check to see if git completion scripts need to be downloaded
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installPackages.sh
$CLI_PACKAGES_SETUP_SCRIPTS_DIR/installNodejs.sh

if [[ "$(ps -p $$ -ocomm=)" == "bash" ]]; then
    $CLI_PACKAGES_SETUP_SCRIPTS_DIR/installGitCompletion.sh
    $CLI_PACKAGES_SETUP_SCRIPTS_DIR/installDocker.sh

    if [[ ! "$OSTYPE" == "darwin"* ]]; then
        $CLI_PACKAGES_SETUP_SCRIPTS_DIR/installRipgrep.sh
    fi

    echo -e "\n\nDownloading and installing applications"

    $APPLICATION_SETUP_SCRIPTS_DIR/VSCode/installVSCode.sh
fi 

echo -e "\nResetting previous dotfiles repo specific if there is any"

. "$SETUP_BASH_DIR/reset.sh"

echo -e "\n\nCreating symlinks"

symlink_or_symlink_as_alt_name_as_necessary "$BASH_BASHRC_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_INPUTRC_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_PROMPT_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_ALIASES_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_EXPORTS_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_PATH_FILE" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$BASH_LIBRARY_FILE" "$HOME"

create_symlink_if_necessary_into_dir "$BASH_LIBRARY_FILE" "$HOME_BIN"

for file in "$REPO_BASH_BIN_DIR"/*; do
    if [ -f "$file" ]; then
        create_symlink_if_necessary_into_dir "$file" "$HOME_BIN"
     fi 
done

create_symlink_if_necessary_into_dir "$XRESOURCES_RESOURCE_FILE" "$HOME"
create_symlink_if_necessary_into_dir "$DIRCOLORS_CONFIG_FILE" "$CONFIG_DIR"
create_symlink_if_necessary_into_dir "$RIPGREP_CONFIG_FILE" "$CONFIG_DIR"
create_symlink_if_necessary_into_dir "$GIT_CONFIG_FILE" "$GIT_CONFIG_DIR"
create_symlink_if_necessary "$TAILSPIN_CONFIG_FOLDER" "$TAILSPING_CONFIG_DIR"

create_symlink_if_necessary "$INTELLJ_IDEA_RUN_SCRIPT" "$INTELLJ_IDEA_USR_LOCAL_BIN"
create_symlink_if_necessary "$PYCHARM_RUN_SCRIPT" "$PYCHARM_USR_LOCAL_BIN"

if [[ ! "$(osname)" == "MacOSX" ]]; then
    create_symlink_if_necessary "$RIPGREP_RUN_SCRIPT" "$RIPGREP_USR_LOCAL_BIN"
fi

if [ -d "$DOTFILES_SECRET_REPO_ROOT" ]; then
    . "$DOTFILES_SECRET_REPO_ROOT/setup/bash/setup.sh"
fi

create_symlink_if_necessary_into_dir "$AI_INSTRUCTIONS_CONFIG_FOLDER" "$COPILOT_HOME_DIR"
create_symlink_if_necessary_into_dir "$AI_SKILLS_CONFIG_FOLDER" "$COPILOT_HOME_DIR"

echo -e "\n\nDone! Please run 'bash -l' in the bash shell to apply changes"
