#!/usr/bin/env zsh

export SDKMAN_DIR="/home/iskova/.sdkman"
[[ -s "/home/iskova/.sdkman/bin/sdkman-init.sh" ]] && source "/home/iskova/.sdkman/bin/sdkman-init.sh"

export AI_CONF_DIR="$HOME/Development/aiconf"
export AI_NOTES_DIR="$HOME/Development/personal-notes"

. ${AI_CONF_DIR}/shared/init.sh
. ${AI_CONF_DIR}/shared/utils.sh
. ${AI_CONF_DIR}/shared/vm.sh
. ${AI_CONF_DIR}/shared/dev.sh
. ${AI_CONF_DIR}/shared/docker.sh
. ${AI_CONF_DIR}/shared/key.sh
. ${AI_CONF_DIR}/shared/network.sh
