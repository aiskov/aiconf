#!/usr/bin/env bash

export VM_DIR="$HOME/VM"

export MONGO_VM="$VM_DIR/mongodb"
export MARIA_VM="$VM_DIR/mariadb"
export MYSQL_VM="$VM_DIR/mysql"

# Managing of virtual box
unset -f vm &&
vmbox() {
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
_vmbox() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    local per_vm=("down" "pause" "resume" "reset" "drop" "info")
    local is_per_vm=(containsElement ${per_vm[@]} ${prev})

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("up" "list" "ps" "info" "down" "pause" "resume" "reset" "drop" "info")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    elif [ ${is_per_vm} ]; then
        local dirs=$(VBoxManage list vms | awk -F '"' '{print $2}' | tr '\n' ' ')
        COMPREPLY=($(compgen -W '$dirs' -- "$cur"))
    fi

    return 0
}
complete -F _vmbox -o default vmbox

# Generic VM manager
which vagrant &> /dev/null &&
unset -f vm &&
vm() {
    local dir=${2:-.}
    if [ ! -f "$dir"/Vagrantfile ]; then
        echo "No Vagrant VM found in directory $dir"
        return 1
    fi

    cd ${dir}

    case "$1" in
        "up")
            vagrant up || true
            ;;
        "down")
            vagrant halt || true
            ;;
        "status")
            vagrant status || true
            ;;
        "reload")
            vagrant reload || true
            ;;
        "rebuild")
            vagrant destroy -f || true
            vagrant up || true
            ;;
        *)
            echo "Incorrect command: $@"
            ;;
    esac

    cd - >> /dev/null
}

which vagrant &> /dev/null &&
unset -f mongo &&
mongo() {
    if [[ $1 = "restore" ]]; then
       cd ${MONGO_VM}
       vagrant ssh -c 'cd /vagrant/ && mongorestore > tmp.log' 2> /dev/null || true
       cat tmp.log || true
       rm tmp.log || true
       cd - >> /dev/null
    else
        vm $1 ${MONGO_VM}
    fi
}

which vagrant &> /dev/null &&
unset -f maria
maria() {
    vm $1 ${MARIA_VM}
}

which vagrant &> /dev/null &&
unset -f mysql
mysql() {
    vm $1 ${MYSQL_VM}
}

unset -f _vm
_vm() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("up" "down" "reload" "rebuild" "status")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    else
        local dirs=$(all_dirs | tr '\n' ' ')
        COMPREPLY=($(compgen -W '$dirs' -- "$cur"))
    fi

    return 0
}
complete -F _vm -o default vm
complete -F _vm -o default mongo
complete -F _vm -o default maria
complete -F _vm -o default mysql