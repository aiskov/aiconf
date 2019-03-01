#!/usr/bin/env bash

# Networking
alias edit_hosts="sudo nano /etc/hosts"


alias open_conn="lsof -i"
alias open_ports="lsof -i | grep LISTEN"

ping_port() {
    nmap -p $2 $1
}
alias flush_dns="dscacheutil -flushcache"
alias flush_dns="sudo killall -HUP mDNSResponder"

alias wifi="netstat -an | grep LISTEN | grep tcp"

if [ $OSTYPE == "darwin" ]
then
    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

    alias wifi_on="networksetup -setairportpower airport on"
    alias wifi_off="networksetup -setairportpower airport off"

    alias my_ip="curl ip.appspot.com && echo"
fi
