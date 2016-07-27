#!/bin/bash

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

brew install bash-completion

brew install ansible

# Install java 
# TODO: Download and install java.

# Install sdkman
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version

# Install java tools
sdk install scala
sdk install groovy
sdk install maven
sdk install sbt
sdk install gradle

# Generate keys
ssh-keygen -t rsa

# Install bash_profile
mkdir -p /Development/aiconf
git clone git@github.com:aiskov/aiconf.git ~/Development/aiconf

rm ~/.bash_profile || true
ln -s ~/Development/aiconf/mac/.bash_profile.sh ~/.bash_profile
