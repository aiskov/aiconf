#!/bin/bash

apt install -y htop
apt install -y docker.io

groupadd docker
sudo usermod -aG docker $USER


curl -s "https://get.sdkman.io" | bash

sdk install java
sdk install groovy


# Others:
# - IntelliJ
# - slack
