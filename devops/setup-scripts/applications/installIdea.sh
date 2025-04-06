#!/bin/bash

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

source $DEVOPS_DIR/constants.sh
source $REPO_BASH_DIR/.functions

if ! shopt -oq posix; then
    INTELLJ_VERSION_AND_NAME="ideaIC-2024.1.4.tar.gz"
    INTELLJ_IDEA_DOWNLOAD_URL="https://download.jetbrains.com/idea/$INTELLJ_VERSION_AND_NAME"
    INTELLJ_IDEA_DOWNLOAD_PATH=$OPT_FOLDER/$INTELLJ_VERSION_AND_NAME

    download_file_if_it_does_not_exist_already  $INTELLJ_IDEA_RUN_SCRIPT $INTELLJ_IDEA_DOWNLOAD_PATH $INTELLJ_IDEA_DOWNLOAD_URL
    if [ -f $INTELLJ_IDEA_DOWNLOAD_PATH ]; then
        sudo tar -xzf $INTELLJ_IDEA_DOWNLOAD_PATH -C $OPT_FOLDER
        sudo rm -rf $INTELLJ_IDEA_DOWNLOAD_PATH
        sudo mv $OPT_FOLDER/idea-* $INTELLJ_IDEA_INSTALL_FOLDER
    fi
fi