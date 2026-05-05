source $HOMEBREW_ROOT/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_PATTERNS
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern regexp)
ZSH_HIGHLIGHT_REGEXP+=('(gc|git commit|gamend|gam) -a?m \"[^"]{52,}' 'fg=red,bold')

# zsh-autosuggest -- select suggestion with Ctrl+N
bindkey '' autosuggest-execute

##########################################################################################
# FZF                                                                                    #
##########################################################################################

export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_TRIGGER=',,'
export FZF_DEFAULT_COMMAND='ag -l --nocolor --hidden -g ""'
export FZF_DEFAULT_OPTS='--height=90% --info=inline --border --margin=1 --padding=1 --prompt="▶ " --pointer=" →" --marker="→ " --cycle --layout=reverse --query="$1" --select-1 --no-multi'

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg:#cbccc6,bg:#1f2430,hl:#707a8c
 --color=fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66
 --color=info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
 --color=marker:#73d0ff,spinner:#73d0ff,header:#d4bfff'

# fzf -- use Ctrl+T to open auto-complete list
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPS='--bind up:preview-up,down:preview-down'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# FZF - fuzzy finder for history search  
# source <(fzf --zsh)

# FZF integration with fd
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Open branch fuzzy finder with ^G^B
_fuzzy_git_branches() {
  zle -U "$(
    git branch --color=always --sort=-committerdate | \
    grep -v '^* ' | \
    grep -v '^\s\+master' | \
    fzf-tmux --reverse --ansi --select-1 | \
    sed -E 's/^[ \t]*//'
  )"
}

zle -N fuzzy-git-branches _fuzzy_git_branches
bindkey '^G^B' fuzzy-git-branches


# load my own completion functions
fpath=(\
  ~/.zsh/completion \
  $HOMEBREW_ROOT/share/zsh-completions \
  $HOMEBREW_ROOT/share/zsh/site-functions \
  $fpath\
)

# completion
autoload -U compinit
compinit