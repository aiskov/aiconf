#!/bin/bash

echo '   _____  .___  _________                _____ '
echo '  /  _  \ |   | \_   ___ \  ____   _____/ ____\'
echo ' /  /_\  \|   | /    \  \/ /  _ \ /    \   __\ '
echo '/    |    \   | \     \___(  <_> )   |  \  |   '
echo '\____|__  /___|  \______  /\____/|___|  /__|   '
echo '        \/              \/            \/       '

# Locations
export ANDROID_HOME=/Users/aiskov/Library/Android/sdk
[[ -d "$ANDROID_HOME" ]] &&  export PATH="$PATH:$ANDROID_HOME/platform-tools"

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
            git commit -m"Save changes"
            git push origin
            ;;
        *)
            echo "Incorrect aiconf command: $@"    
            ;;
    esac
    
    cd - >> /dev/null
}

# Utils
containsElement() {
  local e
  for e in "${2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

join() {
    local IFS="$1"
    shift
    echo "$*"
}

# Navigation
to() {
    case "$1" in
        "dev")
            cd $DEV_DIR
            ;;
        "vm")
            cd $VM_DIR
            ;;
        "log")
            cd $LOG_DIR
            ;;
        *)
            cd
            ;;
    esac
}

# Generic VM manager
which vagrant &> /dev/null &&
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
mongo() {
    if [[ $1 = "restore" ]]; then
       cd ${MONGO_VM}
       vagrant ssh -c 'cd /vagrant/ && mongorestore > tmp.log' 2> /dev/null || true
       cat tmp.log || true
       rm tmp.log || true
       cd - >> /dev/null
    else
        vm ${MONGO_VM} $1
    fi
}

which vagrant &> /dev/null &&
maria() {
    vm ${MARIA_VM} $1
}

which vagrant &> /dev/null &&
mysql() {
    vm ${MYSQL_VM} $1
}

# Development
sublime() {
    nohup /Applications/"Sublime Text.app"/Contents/MacOS/"Sublime Text" $1 2> /dev/null
}

# Media
mov2mp4() {
    ffmpeg -i $1 -vcodec h264 -acodec aac -strict -2 $2
}

# Work with docker
export DOCKER_HOST=unix:///var/run/docker.sock

d() {
    case "$1" in
        "ps")
            case $2 in
                "--names")
                    docker ps --format '{{.Names}}' ${@:3}
                    ;;
                "stopped")
                    docker ps -f "status=exited"
                    ;;
                *)
                    docker ps ${@:2}
                    ;;
            esac
            ;;
        "img")
            docker images ${@:2}
            ;;
        "rmi")
            if [ "$2" = "untagged" ]; then
                TARGETS="$(docker images | grep '"'"'^<none>'"'"' | awk '"'"'{print $3}'"'"')"
                
                if [ -z "$TARGETS" ]; then
                    echo "No $2 images found"
                else
                    docker rmi ${TARGETS}
                fi
            elif [ "$2" = "all" ]; then
                TARGETS="$(docker images -q)"

                if [ -z "$TARGETS" ]; then
                    echo "No images found"
                else
                    docker rmi ${TARGETS}
                fi
            else
                docker rmi ${@:2}
            fi
            ;;
        "pull")
            docker pull ${@:2}
            ;;
        "push")
            docker push ${@:2}
            ;;
        "build")
            docker build -t ${@:2}
            ;;
        "daemon")
            docker daemon ${@:2}
            ;;
        "attach")
            docker attach ${@:2}
            ;;
        "logs")
            docker log ${@:2}
            ;;
        "run")
            docker run -t -i --net=host ${@:2}
            ;;
        "stop")
            if [ "$2" = "all" ]; then
                TARGETS="$(docker ps -q)"
                
                if [ -z "$TARGETS" ]; then
                    echo "No active containers"
                else
                    docker stop ${TARGETS}
                fi
            else
                docker stop ${@:2}
            fi
            ;;
        "rm")
            if [ "$2" = "all" ]; then
                TARGETS="$(docker ps -a -q)"
                
                if [ -z "$TARGETS" ]; then
                    echo "No containers found"
                else
                    docker rm ${TARGETS}
                fi
            else
                docker rm ${@:2}
            fi
            ;;
        "bash")
            docker exec -it $2 /bin/bash ${@:3}
            ;;
        "stats")
            TARGETS="$(d ps --names)"

            if [ -z "$TARGETS" ]; then
                echo "No active containers found"
            else
                if [ "$2" = "" ]; then
                    docker stats ${TARGETS}
                elif [[ $2 == --* ]]; then
                    docker stats ${TARGETS} $2
                else
                    docker stats ${@:2}
                fi
            fi
            ;;
        *)
            echo "Incorrect d command: $@"    
            ;;
    esac        
}

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

unset -f all_dirs
all_dirs() {
    local target
    if [ "$1" = "" ]; then
        target="./"
    else
        target="$1/"
    fi

    local dirs=$(find ${target} -type d -maxdepth 1)
    echo "$dirs" | sed "s|^$target||g" | sed "s|^/||g" | sed '/^\s*$/d'
}

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
[ -d "$DEV_DIR/jiss-provision" ] && . "$DEV_DIR/jiss-provision/aliases.sh"

# SDKMan
[ -d "$SDKMAN_DIR" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Additional completion
[ -f ${BREW_PREFIX}/etc/bash_completion ] && . ${BREW_PREFIX}/etc/bash_completion

# Load autoconfig
. $AI_CONF_DIR/mac/autocomplete.sh

# Load machine specific configs
[ ! -d "~/.bash_profile.d" ] || mkdir ~/.bash_profile.d

load_scripts() {
    cd $1

    for s in $(ls); do
        . ${s}
    done

    cd - &> /dev/null
}

load_scripts ~/.bash_profile.d
