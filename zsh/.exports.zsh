#!/bin/zsh
########################################################################################################################
# Global Exports                                                                                                       #
########################################################################################################################

export EDITOR="vim";
export GOPATH="$HOME/go"

##########################################################################################
# History                                                                                #
##########################################################################################
# History settings.

export HISTTIMEFORMAT="%m/%d/%Y %H:%M:%S" # Timestamps for history
export HISTCONTROL=ignoreboth  # no duplicate entries

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000000                   # big big history
export HISTFILESIZE=1000000               # big big history
export SAVEHIST=1000000                   # big big history
export HISTFILE=~/.zsh_history

setopt share_history
setopt hist_verify

# prepend command with a space, and it won't be written to history
setopt histignorespace

export ERL_AFLAGS="-kernel shell_history enabled"

##########################################################################################
# Zsh                                                                                    #
##########################################################################################

export HOMEBREW_ROOT=$(brew --prefix)