#!/bin/bash

# Exit if script
[ -z "$PS1" ] && return

# Config history
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend

# Dynamic window size
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Config colors
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

echo '   _____  .___  _________                _____ '
echo '  /  _  \ |   | \_   ___ \  ____   _____/ ____\'
echo ' /  /_\  \|   | /    \  \/ /  _ \ /    \   __\ '
echo '/    |    \   | \     \___(  <_> )   |  \  |   '
echo '\____|__  /___|  \______  /\____/|___|  /__|   '
echo '        \/              \/            \/       '

# Locations
# TODO: export ANDROID_HOME=/home/aiskov/<FIX-ME>/Android/sdk
# TODO: uncomment [[ -d "$ANDROID_HOME" ]] &&  export PATH="$PATH:$ANDROID_HOME/platform-tools"

export DEV_DIR="$HOME/Development"
export VM_DIR="$HOME/VM"
export AI_CONF_DIR="$DEV_DIR/aiconf"

export LOG_DIR="/var/log"

export MONGO_VM="$VM_DIR/mongodb"
export MARIA_VM="$VM_DIR/mariadb"
export MYSQL_VM="$VM_DIR/mysql"

export SDKMAN_DIR="$HOME/.sdkman"

export BREW_PREFIX="$(brew --prefix)"

# Configuration management
aiconf() {
    local _cur_dir=$(pwd)
    cd ${AI_CONF_DIR}

    case "$1" in
        "update")
            git pull | grep '|\|Already'
            . ~/.bashrc
            ;;
        "reload")
            . ~/.bashrc
            ;;
        "save")
            git add -A
            git commit -m"[AUTO] Save changes"
            git push origin
            ;;
        *)
            echo "Incorrect aiconf command: $@"
            ;;
    esac

    cd ${_cur_dir} &> /dev/null
}

