#!/bin/bash
set -e

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
nvm install v16
nvm install v18 # This version is specifically needed by some dependencies

