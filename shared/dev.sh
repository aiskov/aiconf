#!/usr/bin/env bash

# Locations
if [ $OSTYPE == "linux-gnu" ]; then
    export ANDROID_HOME=""
else
    export ANDROID_HOME=/Users/aiskov/Library/Android/sdk
fi

[[ -d "$ANDROID_HOME" ]] && export PATH="$PATH:$ANDROID_HOME/platform-tools"

export DEV_DIR="$HOME/Development"


# Navigation
unset -f to
to() {
    case "$1" in
        "dev")
            cd $DEV_DIR
            ;;
        "vm")
            cd $VM_DIR
            ;;
        "log")
            cd $LOG_DIR
            ;;
        *)
            cd
            ;;
    esac
}

# Development
unset -f sublime
sublime() {
    nohup /Applications/"Sublime Text.app"/Contents/MacOS/"Sublime Text" $1 2> /dev/null
}

# Git
alias git_cancel="git reset --soft HEAD~"