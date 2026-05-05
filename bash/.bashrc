#!/bin/bash
########################################################################################################################
# Bashrc                                                                                                               #
########################################################################################################################
# use bash -l in shell to reload changes made in this file

# If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

##########################################################################################
# Shopt commands                                                                         #
##########################################################################################

if [ "$(ps -p $$ -ocomm=)" = "bash" ]; then
    # Check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # Enable ** glob pattern
    shopt -s globstar

    # Prevent Ctrl-D (EOF) from exiting shell
    set -o ignoreeof

    # workaround a bug where otherwise you get '\' prepended to any '$'.
    shopt -s direxpand

    # Autocorrect typos in path names when using `cd`.
    shopt -s cdspell

    # Case-insensitive globbing (used in pathname expansion).
    shopt -s nocaseglob

    # Bash attempts to save all lines of a multiple-line command in the same history entry.
    # This allows easy re-editing of multi-line commands.
    shopt -s cmdhist

    # append to the history file, don't overwrite it
    shopt -s histappend

    # enable strings with !
    set -o histexpand
fi

##########################################################################################
# Terminal                                                                               #
##########################################################################################

if [ -x /usr/bin/dircolors ]; then
    if [[ -r $HOME/.config/.dircolors ]]; then
	    eval "$(dircolors -b "$HOME/.config/.dircolors")"
	else
        eval "$(dircolors -b)"
	fi
fi

##########################################################################################
# Completions                                                                            #
##########################################################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ "$(ps -p $$ -ocomm=)" = "bash" ]; then
    if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
        fi
    fi

    # enable git completion features
    if ! shopt -oq posix; then
        if [ -f /usr/local/share/git-core/contrib/completion/git-completion.bash ]; then
            . /usr/local/share/git-core/contrib/completion/git-completion.bash
        elif [ -f ~/.config/git/.git-completion.bash ]; then
            # This will only exist if you needed to downloaded it
            . ~/.config/git/.git-completion.bash
        fi
    fi
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

##########################################################################################
# Load dotfiles                                                                          #
##########################################################################################
dotfiles_to_load=()
dotfiles_to_load+=("$HOME/.bashrc.secret")
dotfiles_to_load+=("$HOME/.bash_path")
dotfiles_to_load+=("$HOME/.bash_prompt")
dotfiles_to_load+=("$HOME/.bash_aliases")
dotfiles_to_load+=("$HOME/.bash_exports")
dotfiles_to_load+=("$HOME/.bash_library")

# Load our dotfiles.
for file in "${dotfiles_to_load[@]}"; do
    if [[ -f ${file} ]]; then
        source "$file"
    fi
done
unset file

############################################################
# XRESOURCES                                               #
############################################################

if in_SSH_session; then
    xrdb -I$HOME ~/.Xresources
fi

##########################################################################################
# Programs                                                                               #
##########################################################################################

############################################################
# NVM                                                      #
############################################################

if [[ "$(is_wsl)" == "yes" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm use 22.15.1
fi

############################################################
# virtualenvwrapper                                        #
############################################################

export WORKON_HOME=~/python_venvs
[ -s "/usr/local/bin/virtualenvwrapper.sh" ] && source /usr/local/bin/virtualenvwrapper.sh

############################################################
# VS CODE                                                  #
############################################################
if [[ "$(is_wsl)" == "yes" ]]; then
    export DONT_PROMPT_WSL_INSTALL=1
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/BAMBRIGHT/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
