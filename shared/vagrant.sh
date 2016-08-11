#!/usr/bin/env bash

# Generic VM manager
export MONGO_VM="$VM_DIR/mongodb"
export MARIA_VM="$VM_DIR/mariadb"
export MYSQL_VM="$VM_DIR/mysql"

which vagrant &> /dev/null &&
unset -f vg &&
vg() {
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
        vg $1 ${MONGO_VM}
    fi
}

which vagrant &> /dev/null &&
unset -f maria
maria() {
    vg $1 ${MARIA_VM}
}

which vagrant &> /dev/null &&
unset -f mysql
mysql() {
    vg $1 ${MYSQL_VM}
}

unset -f _vg
_vg() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    if [ $COMP_CWORD -eq 1 ]; then
        local options=("up" "down" "reload" "rebuild" "status")
        options=$(join ' ' ${options[@]})
        COMPREPLY=($(compgen -W '$options' -- "$cur"))
    else
        local dirs=$(find . -name Vagrantfile | sed -e 's/\/Vagrantfile*$//g' | tr '\n' ' ')
        COMPREPLY=($(compgen -W '$dirs' -- "$cur"))
    fi

    return 0
}
complete -F _vg vg
complete -F _vg mongo
complete -F _vg maria
complete -F _vg mysql