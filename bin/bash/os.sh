#!/bin/bash
set -euo pipefail
########################################################################################################################
# OS Related Functions                                                                                                 #
########################################################################################################################

##########################################################################################
# Determine OS Functions                                                                 #
##########################################################################################

function osname() {
  case "$OSTYPE" in
    "linux-gnu"*)
      linux_os=$(osname_linux)
      echo "$linux_os"
      ;;
    "darwin"*)
      echo "MacOSX"
      ;;
    "cygwin")           
      # POSIX compatibility layer and Linux environment emulation for Windows
      echo "freebsd"
      ;;
    "msys")           
      # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
      echo "msys"
      ;;
    "win32")
      echo "Windows32"
      ;;
    *)
      echo "Unknown"
      ;;
  esac
}

function osname_linux() {
  os="$(awk -F= '$1=="NAME" {gsub(/"/, "", $2); print $2}' /etc/os-release)"

  case "$os" in
    "Ubuntu")
      echo "Ubuntu"
      ;;
    "CentOS Linux" | "CentOS Stream" | "AlmaLinux" | "Rocky Linux" | "Red Hat Enterprise Linux")
      echo "CentOS"
      ;;
    *)
      echo "Unknown"
      ;;
  esac
}

# returns a non-empty string if this is a Windows machine running Git bash
is_Windows_machine() {
    if [[ "$OSTYPE" == "msys" ]] ; then
        echo true
    fi
}

# returns a non-empty string if this is an x86_64 machine 
is_x86_machine() {
    echo $(uname -a | grep x86_64)
}

function is_wsl() {
  if [[ -f /proc/version ]]; then
    if [[ $(grep -i WSL /proc/version) ]]; then
      echo "yes"
      return 0
    fi
  fi
  
  echo "no"
  return 1
}




