#!/bin/zsh
########################################################################################################################
# MacOS Specific Setup                                                                                                 #
########################################################################################################################

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Disable macOS autofill
# https://discussions.apple.com/thread/256145409?answerId=261593306022&sortBy=rank#261593306022
# defaults write -g NSAutoFillHeuristicControllerEnabled -bool false

# https://discussions.apple.com/thread/256145409?answerId=261593306022&sortBy=rank#261593306022
# Update VS Code, Teams, and any electron apps
# Run this after every restart of the computer:
launchctl setenv CHROME_HEADLESS 1
# Then restart all electron based apps 

