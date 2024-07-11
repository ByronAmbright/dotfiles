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
INTELLJ_IDEA_INSTALL_FOLDER=$OPT_FOLDER/idea
INTELLJ_IDEA_RUN_SCRIPT=$INTELLJ_IDEA_INSTALL_FOLDER/bin/idea.sh
USR_LOCAL_BIN=/usr/local/bin
INTELLJ_IDEA_USR_LOCAL_BIN=$USR_LOCAL_BIN/idea

echo "Setting up dotfiles and environment"

. $DEVOPS_DIR/utils.sh

echo "Resetting previous dotfiles repo specific if there is any"

. $DEVOPS_DIR/reset.sh

echo "Creating directories"
mkdir -p $CONFIG_DIR
mkdir -p $GIT_CONFIG_DIR

echo "Downloading dependencies if necessary"

# Check to see if git completion scripts need to be downloaded
if ! shopt -oq posix; then
    GIT_COMPLETION_DOWNLOAD_URL=https://raw.githubusercontent.com/git/git/master/contrib/completion/
    LOCAL_GIT_CORE_COMPLETION_FOLDER=/usr/local/share/git-core/contrib/completion/

    download_file_if_it_does_not_exist_already  $LOCAL_GIT_CORE_COMPLETION_FOLDER/git-prompt.sh $GIT_CONFIG_DIR/.git-prompt.sh $GIT_COMPLETION_DOWNLOAD_URL/git-prompt.sh
    download_file_if_it_does_not_exist_already  $LOCAL_GIT_CORE_COMPLETION_FOLDER/git-completion.bash $GIT_CONFIG_DIR/.git-completion.bash $GIT_COMPLETION_DOWNLOAD_URL/git-completion.bash

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

echo "Downloading and installing applications"

if ! shopt -oq posix; then
    INTELLJ_VERSION_AND_NAME="ideaIC-2024.1.4.tar.gz"
    INTELLJ_IDEA_DOWNLOAD_URL="https://download.jetbrains.com/idea/$INTELLJ_VERSION_AND_NAME"
    INTELLJ_IDEA_DOWNLOAD_PATH=$OPT_FOLDER/$INTELLJ_VERSION_AND_NAME

    download_file_if_it_does_not_exist_already  $INTELLJ_IDEA_RUN_SCRIPT $INTELLJ_IDEA_DOWNLOAD_PATH $INTELLJ_IDEA_DOWNLOAD_URL
    if [ -f $INTELLJ_IDEA_DOWNLOAD_PATH ]; then
        sudo tar -xzf $INTELLJ_IDEA_DOWNLOAD_PATH -C $OPT_FOLDER
        sudo mv $OPT_FOLDER/idea-* $INTELLJ_IDEA_INSTALL_FOLDER
        sudo rm -rf $INTELLJ_IDEA_DOWNLOAD_PATH
    fi
fi

echo "Creating symlinks"

symlink_or_symlink_as_alt_name_as_necessary "$REPO_BASH_DIR/.bashrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_BASH_DIR/.inputrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_BASH_DIR/.bash_prompt" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_BASH_DIR/.bash_aliases" "$HOME"

symlink_or_symlink_as_alt_name_as_necessary "$REPO_ZSH_DIR/.zshrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_CONFIG_DIR/.dircolors" "$CONFIG_DIR"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_CONFIG_DIR/git/config" "$GIT_CONFIG_DIR"
create_symlink_if_necessary "$INTELLJ_IDEA_RUN_SCRIPT" "$INTELLJ_IDEA_USR_LOCAL_BIN"

echo "Done! Please run 'bash -l' in the bash shell to apply changes"
