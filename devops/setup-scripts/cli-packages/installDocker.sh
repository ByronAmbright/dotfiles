#!/bin/bash
set -ueo pipefail

if [ -x "$(command -v docker)" ]; then
    echo "Docker is already installed. Exiting"
    exit 0
fi

if [[ "$(osname)" == "Ubuntu" ]]; then
  sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y
  curl -sL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/docker-archive.gpg >/dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/docker-archive.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
       | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update -y
  sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin -y

else
  sudo yum install yum-utils -y
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
  sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-buildx-plugin -y
fi

sudo usermod -aG docker $USER

if ! `dirname $BASH_SOURCE`/isincontainer; then
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
  sudo systemctl start docker.service
  sudo chmod ag+rw /var/run/docker /var/run/docker.sock

  sudo mkdir -p /etc/docker
  cat << EOF | sudo tee /etc/docker/daemon.json >/dev/null
{
    "insecure-registries": ["localhost:32000"]
}
EOF
fi
