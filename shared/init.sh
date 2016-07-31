#!/usr/bin/env bash

echo '   _____  .___  _________                _____ '
echo '  /  _  \ |   | \_   ___ \  ____   _____/ ____\'
echo ' /  /_\  \|   | /    \  \/ /  _ \ /    \   __\ '
echo '/    |    \   | \     \___(  <_> )   |  \  |   '
echo '\____|__  /___|  \______  /\____/|___|  /__|   '
echo '        \/              \/            \/       '

# Configuration management
unset -f containsElement
aiconf() {
    local _cur_dir=$(pwd)
    cd ${AI_CONF_DIR}

    case "$1" in
        "update")
            git pull | grep '|\|Already'
            . ~/.bash_profile
            ;;
        "reload")
            . ~/.bash_profile
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
