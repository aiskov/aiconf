#!/usr/bin/env bash

export VM_DIR="$HOME/VM"

# Managing of virtual box
unset -f vm &&
vm() {
    case "$1" in
        "up")
            VBoxManage startvm "$2" --type headless
            ;;
        "list")
            VBoxManage list vms
            ;;
        "ps")
            VBoxManage list runningvms
            ;;
        "info")
            VBoxManage showvminfo "$2"
            ;;
        "down")
            vboxmanage controlvm "$2" acpipowerbutton
            ;;
        "pause")
            vboxmanage controlvm "$2" pause
            ;;
        "resume")
            vboxmanage controlvm "$2" resume
            ;;
        "reset")
            vboxmanage controlvm "$2" reset
            ;;
        "drop")
            vboxmanage controlvm "$2" poweroff
            ;;
        *)
            echo "Incorrect command: $@"
            ;;
    esac
}
_vm() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    local per_vm=("down" "pause" "resume" "reset" "drop" "info")
    local is_per_vm=(containsElement ${per_vm[@]} ${prev})

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("up" "list" "ps" "info" "down" "pause" "resume" "reset" "drop" "info")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    elif [ $COMP_CWORD -eq 2 ]; then
        local dirs=$(VBoxManage list vms | awk -F '"' '{print $2}' | tr '\n' ' ')
        COMPREPLY=($(compgen -W '$dirs' -- "$cur"))
    fi

    return 0
}
complete -F _vm vm