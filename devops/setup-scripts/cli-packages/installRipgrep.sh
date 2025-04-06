#!/bin/bash

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

source $DEVOPS_DIR/constants.sh
source $REPO_BASH_DIR/.functions


# Potentially change to getting latest instead of specific version
# URL="$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r ".assets[] | select(.name | endswith(\"-x86_64-unknown-linux-musl.tar.gz\")) | .browser_download_url")"

if ! shopt -oq posix; then
    RIPGREP_VERSION="14.1.1"
    RIPGREP_VERSION_AND_NAME="ripgrep-$RIPGREP_VERSION-x86_64-unknown-linux-musl.tar.gz"
    RIPGREP_DOWNLOAD_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VERSION/$RIPGREP_VERSION_AND_NAME"
    RIPGREP_DOWNLOAD_PATH=$OPT_FOLDER/$RIPGREP_VERSION_AND_NAME

    download_file_if_it_does_not_exist_already  $RIPGREP_RUN_SCRIPT $RIPGREP_DOWNLOAD_PATH $RIPGREP_DOWNLOAD_URL
    if [ -f $RIPGREP_DOWNLOAD_PATH ]; then
        sudo tar -xzf $RIPGREP_DOWNLOAD_PATH -C $OPT_FOLDER
        sudo rm -rf $RIPGREP_DOWNLOAD_PATH
        sudo mv $OPT_FOLDER/ripgrep-* $RIPGREP_INSTALL_FOLDER
    fi
fi