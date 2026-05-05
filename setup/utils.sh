#!/bin/bash
set -euo pipefail

# ============================================================================
# Setup Utility Functions
#
# Shared utility functions used by setup scripts. Sourced by constants.sh.
# ============================================================================

# Guard against double-sourcing
[[ -n "${_DOTFILES_UTILS_LOADED:-}" ]] && return 0
readonly _DOTFILES_UTILS_LOADED=1

# Walks up the directory tree from the current working directory until it finds
# a directory with the given name that also contains a .git marker, confirming
# it is the correct repository root.
function go_back_until_match() {
  local target_folder="$1"

  while [[ ! -d "$target_folder" ]] || [[ ! -e "$target_folder/.git" ]]; do
    if [[ "$PWD" == "/" ]]; then
      echo "Error: Reached root directory without finding $target_folder." >&2
      return 1
    fi
    cd ..
  done

  echo "$PWD/$target_folder"
}
