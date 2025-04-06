#!/bin/bash

set -e

if [ -x "$(command -v code)" ]; then
    echo "VS Code is already installed. Exiting"
    exit 0
fi

if [[ "$(`dirname $BASH_SOURCE`/osname)" == "Ubuntu" ]]; then
  sudo apt update -y
  sudo apt install software-properties-common apt-transport-https -y
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update -y
  sudo apt install code -y

else
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

  sudo echo [code] | sudo tee /etc/yum.repos.d/vscode.repo
  sudo echo baseurl=https://packages.microsoft.com/yumrepos/vscode | sudo tee -a /etc/yum.repos.d/vscode.repo
  sudo echo enabled=1 | sudo tee -a /etc/yum.repos.d/vscode.repo
  sudo echo gpgcheck=1 | sudo tee -a /etc/yum.repos.d/vscode.repo
  sudo echo gpgkey=https://packages.microsoft.com/keys/microsoft.asc | sudo tee -a /etc/yum.repos.d/vscode.repo

  sudo dnf -y install code
fi
