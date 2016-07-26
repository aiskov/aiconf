#!/bin/bash

# Loactaions
export DEV_DIR="$HOME/Development/"
export VM_DIR="$HOME/VM/"

export LOG_DIR="/var/log/"

export MONGO_VM="$VM_DIR/mongodb/"
export MARIA_VM="$VM_DIR/mariadb/"
export MYSQL_VM="$VM_DIR/mysql/"

export SDKMAN_DIR="$HOME/.sdkman"

# Navigation
alias to_dev="cd $DEV_DIR"
alias to_vm="cd $VM_DIR"
alias to_log="cd $LOG_DIR"

# Generic VM manager
vm() {
    if [ ! -f "$1"/Vagrantfile ]; then
        echo "No Vagrant VM found in directory $1"
        return 1
    fi

    cd $1

    case "$2" in
        "up")
            vagrant up || true
            ;;
        "down")
            vagrant halt || true
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

# Manage mongo
mongo() {
    if [[ $1 = "restore" ]]
    then
       cd $MONGO_VM
       vagrant ssh -c 'cd /vagrant/ && mongorestore > tmp.log' 2> /dev/null || true
       cat tmp.log || true
       rm tmp.log || true
       cd - >> /dev/null
    else
        vm $MONGO_VM $1
    fi
}

# Manage mariadb
maria() {
    vm $MARIA_VM $1
}

# Manage mysql
mysql() {
    vm $MYSQL_VM $1
}

# Development
alias mvn_proxy_on="mv ~/.m2/settings.xml.tmp ~/.m2/settings.xml"
alias mvn_proxy_off="mv ~/.m2/settings.xml ~/.m2/settings.xml.tmp"

function sublime {
    nohup /Applications/"Sublime Text.app"/Contents/MacOS/"Sublime Text" $1 2> /dev/null
}

# Media
function mov2mp4 {
    ffmpeg -i $1 -vcodec h264 -acodec aac -strict -2 $2
}

# Work with docker
alias d_ps="docker ps -a"
alias d_img="docker images"
alias d_img_rm="docker rmi"
alias d_pull="docker pull"
alias d_push="docker push"
alias d_build="docker build -t"
alias d_run="docker run -t -i --net=host"
alias d_stop="docker stop"
alias d_deamon="docker run -d --net=host"
alias d_attach="docker attach"

function d_bash {
    docker exec -it $1 /bin/bash
}

function d_destroy {
    docker stop $1
    docker rm $1
}

alias d_rm_stopped='docker rm $(docker ps -a -q)'
alias d_rm_untagged='docker rmi $(docker images | grep '"'"'^<none>'"'"' | awk '"'"'{print $3}'"'"') > /dev/null'

# Work with proc
alias is_runned="ps aux | grep -v grep | grep"
alias mem_top="ps wwaxm -o pid,%cpu,command | head -5"
alias cpu_top="ps wwaxr -o pid,%cpu,command | head -5"
alias ttop="top -R -F -s 10 -o rsize"
alias be_awake="caffeinate -u -t"

# Work with files
alias watch="tail -f"
alias search="find . -name"
alias rsearch="find . -regex"

# Git
alias git_cancel="git reset --soft HEAD~"

# Networking
alias edit_hosts="sudo nano /etc/hosts"
alias my_ip="curl ip.appspot.com && echo"
alias open_conn="lsof -i"
alias open_ports="lsof -i | grep LISTEN"
alias flush_dns="dscacheutil -flushcache"
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
alias flush_dns="sudo killall -HUP mDNSResponder"
alias wifi_on="networksetup -setairportpower airport on"
alias wifi_off="networksetup -setairportpower airport off"

# Provisioning
[[ -d "$DEV_DIR/jiss-provision" ]] && . "$DEV_DIR/jiss-provision/aliases.sh"

# SDKMan
[[ -d "$SDKMAN_DIR" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
