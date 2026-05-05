#!/bin/bash
set -euo pipefail

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################

# Guard against double-sourcing
[[ -n "${_DOTFILES_CONSTANTS_LOADED:-}" ]] && return 0
readonly _DOTFILES_CONSTANTS_LOADED=1

# Source utility functions (go_back_until_match)
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/utils.sh"

############################################################
# Source Location Variables                                #
############################################################
CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(go_back_until_match "dotfiles")
readonly SETUP_DIR="$REPO_ROOT/setup"
readonly SETUP_BASH_DIR="$SETUP_DIR/bash"
readonly SETUP_ZSH_DIR="$SETUP_DIR/zsh"
readonly SETUP_SCRIPTS_DIR="$SETUP_DIR/setup-scripts"
readonly CLI_PACKAGES_SETUP_SCRIPTS_DIR="$SETUP_SCRIPTS_DIR/cli-packages"
readonly APPLICATION_SETUP_SCRIPTS_DIR="$SETUP_SCRIPTS_DIR/applications"
readonly OS_SETUP_SCRIPTS_DIR="$SETUP_SCRIPTS_DIR/os"
readonly REPO_CONFIG_DIR="$REPO_ROOT/config"
readonly REPO_BASH_DIR="$REPO_ROOT/bash"
readonly REPO_ZSH_DIR="$REPO_ROOT/zsh"
readonly REPO_BIN_DIR="$REPO_ROOT/bin"
readonly REPO_BASH_BIN_DIR="$REPO_BIN_DIR/bash"

############################################################
# Secret Source Location Variables                         #
############################################################
DOTFILES_SECRET_REPO_ROOT=$(cd "$REPO_ROOT"/dotfiles-secret && pwd)

############################################################
# Target Location Variables                                #
############################################################
readonly CONFIG_DIR="$HOME/.config"
SSH_DIR="$HOME/.ssh"
readonly GIT_CONFIG_DIR="$CONFIG_DIR/git"
readonly TAILSPING_CONFIG_DIR="$CONFIG_DIR/tailspin"
readonly COPILOT_HOME_DIR="$HOME/.copilot"
readonly COPILOT_GIT_COMMIT_SKILL_DIR="$COPILOT_HOME_DIR/skills/git-commit-message"

############################################################
# Standard Folder Locations Variables                      #
############################################################
readonly OPT_FOLDER=/opt
readonly USR_LOCAL_BIN=/usr/local/bin
readonly HOME_BIN="$HOME/bin"

############################################################
# Intellj Idea                                             #
############################################################
readonly INTELLJ_IDEA_INSTALL_FOLDER="$OPT_FOLDER/idea"
readonly INTELLJ_IDEA_RUN_SCRIPT="$INTELLJ_IDEA_INSTALL_FOLDER/bin/idea.sh"
readonly INTELLJ_IDEA_USR_LOCAL_BIN="$USR_LOCAL_BIN/idea"

############################################################
# Pycharm                                                  #
############################################################
readonly PYCHARM_INSTALL_FOLDER="$OPT_FOLDER/pycharm"
readonly PYCHARM_RUN_SCRIPT="$PYCHARM_INSTALL_FOLDER/bin/pycharm"
readonly PYCHARM_USR_LOCAL_BIN="$USR_LOCAL_BIN/pycharm"

############################################################
# Ripgrep                                                  #
############################################################
readonly RIPGREP_INSTALL_FOLDER="$OPT_FOLDER/ripgrep"
readonly RIPGREP_RUN_SCRIPT="$RIPGREP_INSTALL_FOLDER/rg"
readonly RIPGREP_USR_LOCAL_BIN="$USR_LOCAL_BIN/rg"

############################################################
# ZSH                                                      #
############################################################
readonly ZSH_ZSHRC_FILE="$REPO_ZSH_DIR/.zshrc"
readonly ZSH_PATH_FILE="$REPO_ZSH_DIR/.path.zsh"
readonly ZSH_EXPORTS_FILE="$REPO_ZSH_DIR/.exports.zsh"
readonly ZSH_OPTIONS_FILE="$REPO_ZSH_DIR/.options.zsh"
readonly ZSH_PLUGINS_FILE="$REPO_ZSH_DIR/.plugins.zsh"
readonly ZSH_MACOS_FILE="$REPO_ZSH_DIR/.macos.zsh"

############################################################
# BASH                                                     #
############################################################
readonly BASH_BASHRC_FILE="$REPO_BASH_DIR/.bashrc"
readonly BASH_INPUTRC_FILE="$REPO_BASH_DIR/.bash_inputrc"
readonly BASH_PROMPT_FILE="$REPO_BASH_DIR/.bash_prompt"
readonly BASH_ALIASES_FILE="$REPO_BASH_DIR/.bash_aliases"
readonly BASH_EXPORTS_FILE="$REPO_BASH_DIR/.bash_exports"
readonly BASH_PATH_FILE="$REPO_BASH_DIR/.bash_path"

readonly BASH_LIBRARY_FILE="$REPO_BIN_DIR/.bash_library"

############################################################
# Config Files                                             #
############################################################
readonly DIRCOLORS_CONFIG_FILE="$REPO_CONFIG_DIR/.dircolors"
readonly RIPGREP_CONFIG_FILE="$REPO_CONFIG_DIR/.ripgreprc"
readonly XRESOURCES_RESOURCE_FILE="$REPO_CONFIG_DIR/.Xresources"
readonly GIT_CONFIG_FILE="$REPO_CONFIG_DIR/git/config"
readonly TAILSPIN_CONFIG_FOLDER="$REPO_CONFIG_DIR/tailspin/"

############################################################
# AI Files                                                 #
############################################################
readonly AI_CONFIG_FOLDER="$REPO_CONFIG_DIR/copilot"
readonly AI_INSTRUCTIONS_CONFIG_FOLDER="$AI_CONFIG_FOLDER/instructions"
readonly AI_SKILLS_CONFIG_FOLDER="$AI_CONFIG_FOLDER/skills"
