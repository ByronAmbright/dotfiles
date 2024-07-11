# .bashrc
# use bash -l in shell to reload changes made in this file

# If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000
SAVEHIST=1000000

# Timestamps for history
export HISTTIMEFORMAT="%m/%d/%Y %H:%M:%S"

HISTCONTROL=ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# save history right away instead of at terminal close
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable ** glob pattern
shopt -s globstar

# Prevent Ctrl-D (EOF) from exiting shell
set -o ignoreeof

# workaround a bug where otherwise you get '\' prepended to any '$'.
shopt -s direxpand

export VISUAL='vim'
export EDITOR='vim'
export FCEDIT='vim'

# Used to prevent prompt from being overridden in certain scripts
export PRESERVE_PROMPT=true

# Show verbose prompt, reduce tabs, handle escape chars, case insensitive
# search, exit if output fits on a single screen
export LESS='--LONG-PROMPT --tabs=4 --RAW-CONTROL-CHARS --ignore-case --quit-if-one-screen'


if [ -x /usr/bin/dircolors ]; then
    if [[ -r $HOME/.config/.dircolors ]]; then
	    eval "$(dircolors -b "$HOME/.config/.dircolors")"
	else
        eval "$(dircolors -b)"
	fi
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#prompt
[[ -f ~/.bash_prompt ]] && . ~/.bash_prompt
[[ -f ~/.personal_bash_prompt ]] && . ~/.personal_bash_prompt

#aliases
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.personal_bash_aliases ]] && . ~/.personal_bash_aliases

#PATH
export PATH=$PATH:"/mnt/c/Program Files/Microsoft VS Code/bin/" 