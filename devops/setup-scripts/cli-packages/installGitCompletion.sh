#!/bin/bash

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

source $DEVOPS_DIR/constants.sh
source $REPO_BASH_DIR/.functions

if ! shopt -oq posix; then
    GIT_COMPLETION_DOWNLOAD_URL=https://raw.githubusercontent.com/git/git/master/contrib/completion/
    LOCAL_GIT_CORE_COMPLETION_FOLDER=/usr/local/share/git-core/contrib/completion

    download_file_if_it_does_not_exist_already  $LOCAL_GIT_CORE_COMPLETION_FOLDER/git-prompt.sh $GIT_CONFIG_DIR/.git-prompt.sh $GIT_COMPLETION_DOWNLOAD_URL/git-prompt.sh
    download_file_if_it_does_not_exist_already  $LOCAL_GIT_CORE_COMPLETION_FOLDER/git-completion.bash $GIT_CONFIG_DIR/.git-completion.bash $GIT_COMPLETION_DOWNLOAD_URL/git-completion.bash
fi
