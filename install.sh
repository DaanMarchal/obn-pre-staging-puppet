#!/bin/bash

BASE_DIR="/etc/puppet/obn-pre-staging-puppet"

sudo apt update
sudo apt install -y git-core make
sudo apt install -y unzip
mkdir -p ${BASE_DIR}
cd ${BASE_DIR}
sudo wget -O obn-pre-staging-puppet.zip https://github.com/DaanMarchal/obn-pre-staging-puppet/raw/master/obn-pre-staging-puppet.zip
unzip -o obn-pre-staging-puppet.zip

sudo wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb

sudo apt update
sudo apt install -y puppet-agent

sudo /opt/puppetlabs/bin/puppet apply --modulepath modules/ manifests/site.pp