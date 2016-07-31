#!/usr/bin/env bash

export VM_DIR="$HOME/VM"

export MONGO_VM="$VM_DIR/mongodb"
export MARIA_VM="$VM_DIR/mariadb"
export MYSQL_VM="$VM_DIR/mysql"

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
