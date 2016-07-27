#!/bin/bash

echo "AI Conf loaded"

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

# Configuration management
aiconf() {
    cd ${AI_CONF_DIR}

    case "$1" in
        "update")
            git pull | grep '|\|Already'
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

# Navigation
to() {
    case "$1" in
        "dev")
            cd $DEV_DIR
            ;;
        "vm")
            cd $VM_DIR
            ;;
        "vm")
            cd $LOG_DIR
            ;;
        *)
            cd
            ;;
    esac
}

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
       cd ${MONGO_VM}
       vagrant ssh -c 'cd /vagrant/ && mongorestore > tmp.log' 2> /dev/null || true
       cat tmp.log || true
       rm tmp.log || true
       cd - >> /dev/null
    else
        vm ${MONGO_VM} $1
    fi
}

# Manage mariadb
maria() {
    vm ${MARIA_VM} $1
}

# Manage mysql
mysql() {
    vm ${MYSQL_VM} $1
}

# Development
alias mvn_proxy_on="mv ~/.m2/settings.xml.tmp ~/.m2/settings.xml"
alias mvn_proxy_off="mv ~/.m2/settings.xml ~/.m2/settings.xml.tmp"

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
                "stopped")
                    docker ps -f "status=exited"
                    ;;
                *)
                    docker ps ${@:2}
                    ;;
            esac
            ;;
        "img")
            docker images
            ;;
        "rmi")
            if [ "$2" = "untagged" ]; then
                TARGETS="$(docker images | grep '"'"'^<none>'"'"' | awk '"'"'{print $3}'"'"')"
                
                if [ -z "$TARGETS" ]; then
                    echo "No containers runned"
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
            docker run -d --net=host ${@:2}
            ;;
        "attach")
            docker attach ${@:2}
            ;;
        "log")
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
        "destroy")
            if [ "$2" = "all" ]; then
                TARGETS="$(docker ps -a -q)"
                
                if [ -z "$TARGETS" ]; then
                    echo "No containers found"
                else
                    docker stop ${TARGETS}
                    docker rm ${TARGETS}
                fi
            else
                docker stop $2
                docker rm $2
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
