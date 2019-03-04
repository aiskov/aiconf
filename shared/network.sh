#!/usr/bin/env bash

# Networking
alias edit_hosts="sudo nano /etc/hosts"

alias open_conn="lsof -i"

unset -f open_ports
open_ports() {
    echo 'lsof -i: '
    lsof -i | grep LISTEN
    
    echo '-----------------------------'
    echo 'netstat -an: '
    netstat -an | grep 'LISTEN '
}

ping_port() {
    nmap -p $2 $1
}
alias flush_dns="dscacheutil -flushcache"
alias flush_dns="sudo killall -HUP mDNSResponder"

alias wifi=""

if [ $OSTYPE == "darwin" ]
then
    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

    alias wifi_on="networksetup -setairportpower airport on"
    alias wifi_off="networksetup -setairportpower airport off"

    alias my_ip="curl ip.appspot.com && echo"
fi
