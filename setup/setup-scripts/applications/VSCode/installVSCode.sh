#!/bin/bash
set -euo pipefail

echo "Installing VS Code"

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

if [[ -x "$(command -v code)" ]]; then
    echo "VS Code is already installed. Exiting"
    exit 0
fi

if [[ "$(osname)" == "Ubuntu" ]]; then
  sudo apt update -y
  sudo apt install software-properties-common apt-transport-https -y
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update -y
  sudo apt install code -y
elif [[ "$(osname)" == "CentOS" ]]; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

  sudo echo [code] | sudo tee /etc/yum.repos.d/vscode.repo
  sudo echo baseurl=https://packages.microsoft.com/yumrepos/vscode | sudo tee -a /etc/yum.repos.d/vscode.repo
  sudo echo enabled=1 | sudo tee -a /etc/yum.repos.d/vscode.repo
  sudo echo gpgcheck=1 | sudo tee -a /etc/yum.repos.d/vscode.repo
  sudo echo gpgkey=https://packages.microsoft.com/keys/microsoft.asc | sudo tee -a /etc/yum.repos.d/vscode.repo

  sudo dnf -y install code
fi
