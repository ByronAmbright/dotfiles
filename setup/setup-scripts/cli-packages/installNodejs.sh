#!/bin/bash
set -euo pipefail

CURRENT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
SETUP_DIR_RELATIVE=$REPO_ROOT/setup

source "$SETUP_DIR_RELATIVE/constants.sh"

function_files_to_load=()
function_files_to_load+=("$REPO_BASH_BIN_DIR/network.sh")
function_files_to_load+=("$REPO_BASH_BIN_DIR/os.sh")

# Source files needed by the script
for file in "${function_files_to_load[@]}"; do
    if [[ -f ${file} ]]; then
        source "$file"
    fi
done
unset file


if ! shopt -oq posix; then
    if [[ ! "$(osname_linux)" == "Unknown" ]]; then
		echo "Installing nodejs"

		if [[ $(which node 2> /dev/null) && "$(which node)" != "$HOME/.nvm/"* ]]; then
			echo "Node is installed without nvm and must be uninstalled before it can be installed using this script"
			exit 1
		fi

		if [[ $(which node 2> /dev/null) && "$(which node)" == "$HOME/.nvm/"* ]]; then
			echo "Node is already installed using nvm"
			exit 0
		fi

		# Install nvm
		echo "Installing nvm and node"
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

		# Source nvm scripts so that this script can use it
		export NVM_DIR="$HOME/.nvm"
		source "$NVM_DIR/nvm.sh"

		# Install node & npm
		nvm install v16 >/dev/null 2>/dev/null || true # This version is specifically needed by some dependencies
		nvm install v18 >/dev/null 2>/dev/null || true # This version is specifically needed by some dependencies
		nvm install 22.22.1 >/dev/null 2>/dev/null || true # This version is specifically needed by some dependencies
    fi
fi


# Install any dependencies that are needed to be installed globally using npm here

npm install -g eslint

