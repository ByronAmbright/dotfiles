#!/bin/
########################################################################################################################
# PATH                                                                                                                 #
########################################################################################################################

# Make sure my $PATH has everything I need

# Add directories to $PATH if they're not there already

_addpath() {
    case :$PATH: in
        *:$1:*)
            # already have it on the path
            ;;
        *)
            PATH=$1:$PATH
            ;;
    esac
}

_addpath_if_exists() {
    test -d "$1" && _addpath "$1"
}

_addpath "$HOME"/.local/bin
_addpath "$HOME"/bin # this ought to be last so ~/bin is first in path
_addpath "$HOME"/repos/dotfiles/bin
_addpath_if_exists "$$ANDROID_HOME"/platform-tools
_addpath_if_exists "$$ANDROID_HOME"/tools
_addpath_if_exists $(brew --prefix coreutils)/libexec/gnubin

export PATH

[[ -f ~/.path_secret ]] && . ~/.path_secret
true