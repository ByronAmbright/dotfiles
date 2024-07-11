# Enable aliases of color support of ls and related commands that use dircolors
if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --group-directories-first --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Shorthand Aliases
# ls
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"

# git
alias glog='git log --decorate=full --oneline --graph'

# Launch intellj idea assuming its installed
alias idea='(nohup idea >> ~/nohup.out &)'

