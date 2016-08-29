#!/bin/bash

apt-get update 
apt-get upgrade -y
apt-get install -y git

git clone git@github.com:aiskov/aiconf.git
