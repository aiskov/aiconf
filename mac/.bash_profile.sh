#!/usr/bin/env bash

# Locations
export AI_CONF_DIR="$HOME/Development/aiconf"
export BREW_PREFIX="$(brew --prefix)"

. ${AI_CONF_DIR}/shared/init.sh
. ${AI_CONF_DIR}/shared/utils.sh
. ${AI_CONF_DIR}/shared/network.sh
. ${AI_CONF_DIR}/shared/vm.sh
. ${AI_CONF_DIR}/shared/vagrant.sh
. ${AI_CONF_DIR}/shared/dev.sh
. ${AI_CONF_DIR}/shared/docker.sh
. ${AI_CONF_DIR}/shared/key.sh

# Media
unset -f mov2mp4
mov2mp4() {
    ffmpeg -i $1 -vcodec h264 -acodec aac -strict -2 $2
}

unset -f kill_firefox
kill_firefox() {
    if [ -f "/Applications/Firefox.app/Contents/MacOS/firefox-bin" ]; then
        killall firefox-bin
    else
        killall firefox
    fi
}

alias kill_chrome="killall 'Google Chrome Helper' && killall 'Google Chrome'"
alias kill_safari="killall Safari && killall SafariCloudHistoryPushAgent && killall com.apple.Safari.ImageDecoder"
alias kill_mysql_workbench="killall MySQLWorkbench"

# SDKMan
export SDKMAN_DIR="$HOME/.sdkman"
[ -d "$SDKMAN_DIR" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Additional completion
[ -f ${BREW_PREFIX}/etc/bash_completion ] && . ${BREW_PREFIX}/etc/bash_completion

# Run sync 
${AI_CONF_DIR}/mac/backup.sh 2>&1 >> ${AI_BACKUP_REPORT} &

# Load machine specific configs
[ ! -d ~/.bash_profile.d ] && mkdir ~/.bash_profile.d
load_scripts ~/.bash_profile.d
