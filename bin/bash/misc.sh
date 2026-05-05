#!/bin/bash
set -euo pipefail
########################################################################################################################
# Misc Functions                                                                                                       #
########################################################################################################################

##########################################################################################
# Docker                                                                                 #
##########################################################################################

function migrate_tar_to_docker_volume() {
  for file in *.tar; do
    echo $file
    y=${file%.tar}
    echo $y
    docker-volume-snapshot restore $file $y
  done
}

function isInContainer() {
  if grep -q docker /proc/1/cgroup || grep -q kubepods /proc/1/cgroup; then
    exit 0
  else
    exit 1
  fi
}

##########################################################################################
# Git Related Functions                                                                 #
##########################################################################################

function remove_indention_on_empty_lines_on_git_changes() {
  # Get the list of files with changes
  files=$(git diff --name-only)

  # Loop through each file
  while read -r file; do
    # Use sed to remove indentation on empty lines
    sed -i 's/^[[:space:]]*$//' "$file"
  done <<< "$files"
}
