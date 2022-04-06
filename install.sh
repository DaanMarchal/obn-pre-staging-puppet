#!/bin/bash

BASE_DIR="/etc/puppet/obn-pre-staging-puppet"

sudo apt update
sudo apt install -y git-core make net-tools software-properties-common unzip udev network-manager

# TODO: -y?
sudo add-apt-repository ppa:deadsnakes/ppa

sudo wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb
sudo rm puppet7-release-focal.deb

sudo apt update
sudo apt install -y puppet-agent
sudo apt install -y python3.10 python3.10-venv

sudo mkdir -p ${BASE_DIR}
cd ${BASE_DIR}
sudo wget -O obn-pre-staging-puppet.zip https://github.com/DaanMarchal/obn-pre-staging-puppet/raw/master/obn-pre-staging-puppet.zip
sudo unzip -o obn-pre-staging-puppet.zip
sudo obn-pre-staging-puppet.zip

#sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
#sudo systemctl restart NetworkManager
#sudo nmcli con add type vlan ifname vlan100 dev eth0 id 100 ip4 192.168.200.254/24
#sudo nmcli connection up vlan-vlan100

./login.sh



sudo /opt/puppetlabs/bin/puppet apply -v --debug --test --modulepath modules/ --hiera_config hiera.yaml manifests/site.pp
