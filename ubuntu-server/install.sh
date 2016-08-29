#!/bin/bash

apt-get update 
apt-get upgrade -y
apt-get install -y git

git clone git@github.com:aiskov/aiconf.git

git clone git@github.com:aiskov/aiconf.git

mv .bashrc .bashrc_old
ln -s aiconf/ubuntu-server/bashrc.sh .bashrc

apt-get install docker -y
