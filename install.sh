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

sudo touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
systemctl restart NetworkManager
sudo nmcli con add type vlan ifname vlan100 dev eth0 id 100 ip4 192.168.200.254/24
nmcli connection up vlan-vlan100

# gather login creds
echo "Login to obn-pre-staging application:"
read -p 'Username: ' uservar </dev/tty

read -sp 'Password: ' passvar </dev/tty
echo ""

# store creds in hiera
sed -i "s,obn_pre_staging::username: \".*\",obn_pre_staging::username: \"$uservar\"", ./hieradata/common.yaml
sed -i "s,obn_pre_staging::password: \".*\",obn_pre_staging::password: \"$passvar\"", ./hieradata/common.yaml



sudo /opt/puppetlabs/bin/puppet apply -v --debug --test --modulepath modules/ --hiera_config hiera.yaml manifests/site.pp
