#!/bin/bash
set -ueo pipefail

CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/../../.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops

source $DEVOPS_DIR/constants.sh
source $REPO_BASH_DIR/.functions

if [[ "$(osname)" == "Ubuntu" ]]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt autoremove -y
  sudo apt install -y apt-transport-https ca-certificates git-gui net-tools traceroute cifs-utils dnsutils rsync curl jq \ 
 autofs nfs-common nfs4-acl-tools ruby p7zip-full zip unzip rlwrap nmap ldap-utils pinentry-tty pass gnupg xmlstarlet \
 lsb-release gnome-system-monitor xterm gedit gimp nautilus pcmanfm btop vim python3-virtualenvwrapper npm

else
  sudo dnf update -y --allowerasing --skip-broken --nobest
  sudo dnf install -y epel-release git-gui net-tools gnome-system-monitor curl jq autofs ruby gnupg p7zip p7zip-plugins xterm \
 rlwrap unzip snapd xmlstarlet git-core openldap-clients rsync btop vim
fi
