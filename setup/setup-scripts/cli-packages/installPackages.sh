#!/bin/bash

set -ueo pipefail

echo "Installing cli packages through package managers"

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

if [[ "$(osname)" == "Ubuntu" ]]; then
  echo -e "\nDownloading Ubuntu dependencies if necessary"
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  ubuntu_packages=(
    apt-transport-https ca-certificates bat git-gui net-tools traceroute
    cifs-utils dnsutils rsync curl jq autofs nfs-common nfs4-acl-tools
    ruby p7zip-full zip unzip rlwrap nmap ldap-utils pinentry-tty pass
    gnupg xmlstarlet lsb-release gnome-system-monitor xterm gedit gimp
    nautilus pcmanfm btop vim python3-virtualenvwrapper npm speedtest-cli
  )
  sudo apt install -y "${ubuntu_packages[@]}"
elif [[ "$(osname)" == "MacOSX" ]]; then
  echo -e "\nDownloading MacOSX dependencies if necessary"
  brew update
  brew upgrade
  brew bundle --file ${REPO_ROOT}/config/Brewfile
  brew cleanup
elif [[ "$(osname)" == "CentOS" ]]; then
  echo -e "\nDownloading CentOS dependencies if necessary"
  sudo dnf update -y --allowerasing --skip-broken --nobest
  sudo dnf install -y bat epel-release git-gui net-tools gnome-system-monitor curl jq autofs ruby gnupg p7zip p7zip-plugins xterm \
 rlwrap unzip snapd xmlstarlet git-core openldap-clients rsync btop vim
fi
