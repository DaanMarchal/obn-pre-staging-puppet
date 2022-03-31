#!/bin/bash

BASE_DIR="/etc/puppet/obn-pre-staging-puppet"

sudo apt update
sudo apt install -y git-core make net-tools software-properties-common unzip netplan.io udev

# TODO: -y?
sudo add-apt-repository ppa:deadsnakes/ppa

sudo wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
rm puppet7-release-focal.deb

sudo apt update
sudo apt install -y puppet-agent
sudo apt install -y python3.10 python3.10-venv

mkdir -p ${BASE_DIR}
cd ${BASE_DIR}
sudo wget -O obn-pre-staging-puppet.zip https://github.com/DaanMarchal/obn-pre-staging-puppet/raw/master/obn-pre-staging-puppet.zip
unzip -o obn-pre-staging-puppet.zip
rm obn-pre-staging-puppet.zip

sudo wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
rm puppet7-release-focal.deb

#ip addr add 192.168.1.254/24 dev eth0
#ip addr add 192.168.16.254/24 dev eth0
#ip addr add 192.168.100.254/24 dev eth0
#ip addr add 192.168.0.254/24 dev eth0

sudo /opt/puppetlabs/bin/puppet apply -v --debug --test --modulepath modules/ manifests/site.pp

# gather login creds
echo "Login to obn-pre-staging application:"
read -p 'Username: ' uservar </dev/tty

read -sp 'Password: ' passvar </dev/tty
echo ""
# store creds in hiera
sed -i "s,username: \".*\",username: \"$uservar\"", /etc/obn-pre-staging/login.yaml
sed -i "s,password: \".*\",password: \"$passvar\"", /etc/obn-pre-staging/login.yaml
