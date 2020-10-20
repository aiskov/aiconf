#!/bin/bash

sudo apt-get update 
sudo apt-get upgrade -y
sudo apt-get install -y git zsh python3-venv htop

curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 15.0.0-zulu
sdk install java 11.0.8-zulu
sdk install java 8.0.265-zulu
sdk install gradle

git clone git@github.com:aiskov/aiconf.git

mv ~/.bashrc ~/.bashrc_old
ln -s aiconf/ubuntu/bashrc.sh ~/.bashrc

mv ~/.zshrc ~/.zshrc_old
ln -s aiconf/ubuntu/zshrc.sh ~/.zshrc

chsh -s $(which zsh)
