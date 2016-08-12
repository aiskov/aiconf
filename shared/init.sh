#!/usr/bin/env bash

echo '   _____  .___  _________                _____ '
echo '  /  _  \ |   | \_   ___ \  ____   _____/ ____\'
echo ' /  /_\  \|   | /    \  \/ /  _ \ /    \   __\ '
echo '/    |    \   | \     \___(  <_> )   |  \  |   '
echo '\____|__  /___|  \______  /\____/|___|  /__|   '
echo '        \/              \/            \/       '

# Configuration management
unset -f aiconf
aiconf() {
    if [ $OSTYPE == "linux-gnu" ]; then
        local bash_profile=$HOME/.bashrc
    else
        local bash_profile=$HOME/.bash_profile
    fi

    local _cur_dir=$(pwd)
    cd ${AI_CONF_DIR}

    case "$1" in
        "update")
            git pull | grep '|\|Already'
            . ${bash_profile}
            ;;
        "reload")
            . ${bash_profile}
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

unset -f _aiconf
_aiconf() {
    local cur
    _get_comp_words_by_ref cur
    COMPREPLY=( $( compgen -W 'save reload update' -- "$cur" ) )

    return 0
}
complete -F _aiconf -o default aiconf