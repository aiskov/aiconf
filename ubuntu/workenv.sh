#!/bin/bash

apt install -y htop
apt install -y docker.io
apt install -y docker-compose
apt install -y net-tools
apt install -y nmap

groupadd docker
sudo usermod -aG docker $USER


curl -s "https://get.sdkman.io" | bash

sdk install java
sdk install groovy
sdk install gradle

# Others:
# - IntelliJ
# - slack
# - Visual Studio Code
# - Chrome
#
# IntelliJ Plugins:
# - Lombok
# - .Ignore
# - Checkstyle
# - Sonar Lint
# - Bash
#
# Chrome configuration:
# - 1Password
# - Langauges: Polish, Russian
