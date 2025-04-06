#!/bin/bash

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

source $DEVOPS_DIR/constants.sh
source $REPO_BASH_DIR/.functions

if ! shopt -oq posix; then
    PYCHARM_VERSION_AND_NAME="pycharm-community-2024.2.3.tar.gz"
    PYCHARM_DOWNLOAD_URL="https://download.jetbrains.com/python/$PYCHARM_VERSION_AND_NAME"
    PYCHARM_DOWNLOAD_PATH=$OPT_FOLDER/$PYCHARM_VERSION_AND_NAME

    download_file_if_it_does_not_exist_already  $PYCHARM_RUN_SCRIPT $PYCHARM_DOWNLOAD_PATH $PYCHARM_DOWNLOAD_URL
    if [ -f $PYCHARM_DOWNLOAD_PATH ]; then
        sudo tar -xzf $PYCHARM_DOWNLOAD_PATH -C $OPT_FOLDER
        sudo rm -rf $PYCHARM_DOWNLOAD_PATH
        sudo mv $OPT_FOLDER/pycharm-* $PYCHARM_INSTALL_FOLDER
    fi
fi