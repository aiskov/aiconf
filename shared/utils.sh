#!/usr/bin/env bash

export LOG_DIR="/var/log"

# Utils
do_times() {
    local i="0"

    while [ $i -lt ${2:-3} ]; do
        $1
        sleep ${3:-1}
        i=$[$i+1]
    done
}

unset -f containsElement
containsElement() {
  local e
  for e in "${2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

unset -f join
join() {
    local IFS="$1"
    shift
    echo "$*"
}

unset -f load_scripts
load_scripts() {
    cd $1

    for s in $(ls); do
        . ${s}
    done

    cd - &> /dev/null
}

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

# Work with proc
alias is_runned="ps aux | grep -v grep | grep"
alias mem_top="ps wwaxm -o pid,%cpu,command | head -5"
alias cpu_top="ps wwaxr -o pid,%cpu,command | head -5"
alias ttop="top -R -F -s 10 -o rsize"
alias be_awake="caffeinate -u -t"

# Work with date
alias aid_week='date +%V'
alias aid_date='date "+%Y-%m-%d"'
alias aid_time='date "+%H:%M:%S"'
alias aid_date_time='date "+%Y-%m-%dT%H:%M:%S"'

# Work with files
alias watch="tail -f"
alias search="find . -name"
alias rsearch="find . -regex"

# Networking
alias edit_hosts="sudo nano /etc/hosts"
alias my_ip="curl ip.appspot.com && echo"
alias open_conn="lsof -i"
alias open_ports="lsof -i | grep LISTEN"
ping_port() {
    nmap -p $2 $1
}
alias flush_dns="dscacheutil -flushcache"
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
alias flush_dns="sudo killall -HUP mDNSResponder"
alias wifi_on="networksetup -setairportpower airport on"
alias wifi_off="networksetup -setairportpower airport off"