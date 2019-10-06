#!/usr/bin/env bash

echo "It's list of commands not a script!"
exit 0

# Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Command line tools
brew install git
brew install curl
brew install wget
brew install icdiff
brew install ffmpeg
brew install p7zip
brew install HTTPie
brew install gnupg
brew install ssh-copy-id
brew install links
brew install watch
brew install mdp

brew install npm
npm install -g grunt
npm install -g cordova ionic phonegap

npm install -g grunt-contrib-concat
npm install -g grunt-contrib-uglify
npm install -g grunt-contrib-cssmin
npm install -g grunt-contrib-htmlmin

brew install bash-completion

brew install jenv
brew install jmeter

brew cask install 1password
brew cask install 1password-cli
brew cask install fork
brew cask install intellij-idea
brew cask install postman
brew cask install visual-studio-code
brew cask install android-studio
brew cask install docker
brew cask install kitematic
brew cask install virtualbox
brew cask install virtualbox-extension-pack
brew cask install visualvm

brew cask install vagrant
brew cask install soapui
# removed: brew cask install mysqlworkbench
brew cask install robo-3t

brew cask install libreoffice
brew cask install vlc
brew cask install spotify
brew cask install gimp
brew cask install pixlr
brew cask install skitch
brew cask install keystore-explorer
brew cask install sourcetree
brew cask install slack
brew cask install skype

brew cask install etcherbe

brew install arp-scan

brew install ansible

# Install sdkman
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version

# Install java 
sdk install java

# Install JVM languages
sdk install scala
sdk install groovy
sdk install kotlin

# Install java tools
sdk install maven
sdk install sbt
sdk install ant
sdk install gradle

# Install python tools
sudo easy_install-3.5 pip
sudo easy_install pip

sudo pip install virtualenv
sudo pip install virtualenvwrapper

sudo pip install pymongo
sudo pip install cassandra-driver
sudo pip install requests
sudo pip install execsql

sudo pip3 install ipython

sudo pip3 install pymongo
sudo pip3 install cassandra-driver
sudo pip3 install requests
sudo pip3 install execsql

# Generate keys
ssh-keygen -t rsa

# Install bash_profile
mkdir -p /Development/aiconf
git clone git@github.com:aiskov/aiconf.git ~/Development/aiconf

rm ~/.bash_profile || true
ln -s ~/Development/aiconf/mac/.bash_profile.sh ~/.bash_profile
