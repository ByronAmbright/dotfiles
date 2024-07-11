#!/bin/bash -eu

# Source Location Variables
CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops
REPO_CONFIG_DIR=$REPO_ROOT/.config
REPO_BASH_DIR=$REPO_ROOT/.bash
REPO_ZSH_DIR=$REPO_ROOT/.zsh

# Target Location Variables
CONFIG_DIR=$HOME/.config
GIT_CONFIG_DIR=$CONFIG_DIR/git
OPT_FOLDER=/opt
USR_LOCAL_BIN=/usr/local/bin
INTELLJ_IDEA_INSTALL_FOLDER=$OPT_FOLDER/idea
INTELLJ_IDEA_RUN_SCRIPT=$INTELLJ_IDEA_INSTALL_FOLDER/bin/idea.sh

echo "Reset dotfiles and environment to original state"

. $DEVOPS_DIR/utils.sh

echo "Removing dependencies if they exist"

rm $GIT_CONFIG_DIR/.git-prompt.sh || true
rm $GIT_CONFIG_DIR/.git-completion.bash || true

echo "Removing symlinks"

remove_symlinks_of_source_file "$REPO_BASH_DIR/.bashrc"
remove_symlinks_of_source_file "$REPO_BASH_DIR/.inputrc"
remove_symlinks_of_source_file "$REPO_BASH_DIR/.bash_prompt"
remove_symlinks_of_source_file "$REPO_BASH_DIR/.bash_aliases"

remove_symlinks_of_source_file "$REPO_ZSH_DIR/.zshrc"
remove_symlinks_of_source_file "$REPO_CONFIG_DIR/.dircolors"
remove_symlinks_of_source_file "$REPO_CONFIG_DIR/git/config"
remove_symlinks_of_source_file "$INTELLJ_IDEA_RUN_SCRIPT" "$USR_LOCAL_BIN"

echo "Removing directories if they are empty"

rm -d $GIT_CONFIG_DIR || true

echo "Done Resetting! Please run 'bash -l' in the bash shell to apply changes"

