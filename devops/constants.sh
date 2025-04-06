#!/bin/bash
########################################################################################################################
# Aliases                                                                                                              #
########################################################################################################################

function go_back_until_match() {
  target_folder="$1"

  while [ ! -d "$target_folder" ]; do
    if [ "$PWD" == "/" ]; then
      echo "Error: Reached root directory without finding $target_folder."
      return 1
    fi
    cd ..
  done

  echo "$PWD/$target_folder"
}

############################################################
# Source Location Variables                                #
############################################################
CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(go_back_until_match "dotfiles")
DEVOPS_DIR=$REPO_ROOT/devops
SETUP_SCRIPTS_DIR=$DEVOPS_DIR/setup-scripts
CLI_PACKAGES_SETUP_SCRIPTS_DIR=$SETUP_SCRIPTS_DIR/cli-packages
APPLICATION_SETUP_SCRIPTS_DIR=$SETUP_SCRIPTS_DIR/applications
REPO_CONFIG_DIR=$REPO_ROOT/config
REPO_BASH_DIR=$REPO_ROOT/bash
REPO_ZSH_DIR=$REPO_ROOT/zsh

############################################################
# Secret source Location Variables                         #
############################################################
DOTFILES_SECRET_REPO_ROOT=$(cd "$REPO_ROOT"/../dotfiles-secret && pwd)
DOTFILES_SECRET_REPO_BASH_DIR=$DOTFILES_SECRET_REPO_ROOT/bash

############################################################
# Target Location Variables                                #
############################################################
CONFIG_DIR=$HOME/.config
GIT_CONFIG_DIR=$CONFIG_DIR/git

############################################################
# Standard Folder Locations Variables                      #
############################################################
OPT_FOLDER=/opt
USR_LOCAL_BIN=/usr/local/bin

############################################################
# Intellj Idea                                             #
############################################################
INTELLJ_IDEA_INSTALL_FOLDER=$OPT_FOLDER/idea
INTELLJ_IDEA_RUN_SCRIPT=$INTELLJ_IDEA_INSTALL_FOLDER/bin/idea.sh
INTELLJ_IDEA_USR_LOCAL_BIN=$USR_LOCAL_BIN/idea

############################################################
# Pycharm                                                  #
############################################################
PYCHARM_INSTALL_FOLDER=$OPT_FOLDER/pycharm
PYCHARM_RUN_SCRIPT=$PYCHARM_INSTALL_FOLDER/bin/pycharm
PYCHARM_USR_LOCAL_BIN=$USR_LOCAL_BIN/pycharm

############################################################
# Ripgrep                                                  #
############################################################
RIPGREP_INSTALL_FOLDER=$OPT_FOLDER/ripgrep
RIPGREP_RUN_SCRIPT=$RIPGREP_INSTALL_FOLDER/rg
RIPGREP_USR_LOCAL_BIN=$USR_LOCAL_BIN/rg

############################################################
# ZSH                                                      #
############################################################
ZSH_ZSHRC_FILE="$REPO_ZSH_DIR/.zshrc"

############################################################
# BASH                                                     #
############################################################
BASH_BASHRC_FILE="$REPO_BASH_DIR/.bashrc"
BASH_INPUTRC_FILE="$REPO_BASH_DIR/.inputrc"
BASH_PROMPT_FILE="$REPO_BASH_DIR/.bash_prompt"
BASH_ALIASES_FILE="$REPO_BASH_DIR/.bash_aliases"
BASH_FUNCTIONS_FILE="$REPO_BASH_DIR/.functions"
BASH_EXPORTS_FILE="$REPO_BASH_DIR/.exports"
BASH_PATH_FILE="$REPO_BASH_DIR/.path"

BASH_BASHRC_SECRET_FILE="$DOTFILES_SECRET_REPO_BASH_DIR/.bashrc_secret"
BASH_PATH_SECRET_FILE="$DOTFILES_SECRET_REPO_BASH_DIR/.path_secret"

BASH_BASHRC_SECRET_FILE_TARGET_LOCATION="$HOME/.bashrc_secret"
BASH_PATH_SECRET_FILE_TARGET_LOCATION="$HOME/.path_secret"

############################################################
# Config Files                                             #
############################################################
DIRCOLORS_CONFIG_FILE="$REPO_CONFIG_DIR/.dircolors"
RIPGREP_CONFIG_FILE="$REPO_CONFIG_DIR/.ripgreprc"
XRESOURCES_RESOURCE_FILE="$REPO_CONFIG_DIR/.Xresources"

############################################################
# Git                                                      #
############################################################
GIT_CONFIG_FOLDER="$REPO_CONFIG_DIR/git/config"


