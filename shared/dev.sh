#!/usr/bin/env bash

# Locations
if [ $OSTYPE == "linux-gnu" ]; then
    export ANDROID_HOME=""
else
    export ANDROID_HOME=/Users/aiskov/Library/Android/sdk
fi

[[ -d "$ANDROID_HOME" ]] && export PATH="$PATH:$ANDROID_HOME/platform-tools"

export DEV_DIR="$HOME/Development"

# Development
unset -f sublime
sublime() {
    nohup /Applications/"Sublime Text.app"/Contents/MacOS/"Sublime Text" $1 2> /dev/null
}

# Git
alias git_cancel="git reset --soft HEAD~"

json() {
    echo ${1} | python -m json.tool
}