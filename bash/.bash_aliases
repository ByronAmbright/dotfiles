#!/bin/bash
########################################################################################################################
# Aliases                                                                                                              #
########################################################################################################################

dotfiles_to_load=()
dotfiles_to_load+=("$HOME/.functions")

# Load our dotfiles.
for file in "${dotfiles_to_load[@]}"; do
    if [[ -f ${file} ]]; then
        source "$file"
    fi
done
unset file

##########################################################################################
# Dircolor Related Aliases                                                               #
##########################################################################################
# Enable aliases of color support of ls and related commands that use dircolors
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --group-directories-first --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

##########################################################################################
# Shorthand Aliases                                                                      #
##########################################################################################

############################################################
# LS                                                       #
############################################################
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

############################################################
# Git                                                      #
############################################################
alias glog='git log --decorate=full --oneline --graph'


############################################################
# VS CODE                                                  #
############################################################

# if ! in_SSH_session; then
#     alias code="/mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code "
# fi

############################################################
# Xterm                                                    #
############################################################
# Launch Intellj products assuming they are installed
alias idea='xterm -e idea &'
alias pycharm='xterm -e pycharm &'

############################################################
# Ripgrep                                                  #
############################################################


rg_hyperlink_format=
if ! in_SSH_session; then
    rg_hyperlink_format="vscode://file//{wslprefix}{path}:{line}:{column}"
elif [[ "$(is_wsl)" == "yes" ]]; then
    rg_hyperlink_format="vscode://vscode-remote/ssh-remote+wncuser@byronambrightjr-work:2222/{path}:{line}:{column}"
else
    rg_hyperlink_format="vscode"
fi

alias rg="rg --hyperlink-format=$rg_hyperlink_format"
alias rrg="reset && rg"

unset rg_hyperlink_format


############################################################
# Misc                                                     #
############################################################
alias pip=pip3
alias p="ps aux | grep "
