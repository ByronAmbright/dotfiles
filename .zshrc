# .zshrc
# Not finished. Needs to be expanded on.

setopt PROMPT_SUBST
PROMPT='%{$fg[green]%}%n:%{$fg_bold[blue]%}%2~ $(git_prompt_info)%{$reset_color%}%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
