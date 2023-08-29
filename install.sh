#!/bin/bash

echo "Updating package list..."
sudo apt-get update

echo "Installing Git..."
sudo apt-get install -y git
echo "Git installed successfully."

echo "Downloading and installing cURL..."
sudo apt-get install -y build-essential libssl-dev
cd /tmp
wget https://curl.se/download/curl-7.79.0.tar.gz
tar -xzf curl-7.79.0.tar.gz
cd curl-7.79.0
./configure --with-ssl
make
sudo make install
sudo ldconfig
echo "cURL installed successfully."

echo "Installing Docker..."
sudo apt-get install -y docker-compose
echo "Docker installed successfully."

echo "Starting Docker daemon..."
sudo systemctl start docker

echo "Adding current user to Docker group..."
sudo usermod -a -G docker $USER
echo "User added to Docker group successfully."

echo "Installing jq..."
sudo apt-get install -y jq
echo "jq installed successfully."

echo "Installing Go..."
sudo apt update && apt upgrade -y
curl -LO https://go.dev/dl/go1.18beta1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.18beta1.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
source ~/.bashrc
echo "Go installed successfully."

echo "Downloading Hyperledger Fabric 2.5 binaries..."
cd /tmp
curl -sSL https://github.com/hyperledger/fabric/releases/download/v2.5.0/hyperledger-fabric-linux-amd64-2.5.0.tar.gz | tar xz
echo "Hyperledger Fabric 2.5 binaries downloaded successfully."

echo "Moving Hyperledger Fabric binaries to /usr/local/bin..."
sudo mv fabric-samples/bin/* /usr/local/bin/
echo "Hyperledger Fabric binaries moved successfully."

echo "Verifying installations..."
git --version
curl --version
docker --version
docker-compose --version
peer version
orderer version
jq --version
go version

echo "All dependencies installed successfully."
