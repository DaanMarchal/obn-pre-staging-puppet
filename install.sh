#!/bin/bash

BASE_DIR="/etc/puppet/obn-pre-staging-puppet"

apt update
apt install wget git-core make sudo
mkdir ${BASE_DIR}
cd ${BASE_DIR}
# wget zip
# unzip

sudo wget https://apt.puppet.com/puppet7-release-focal.deb
sudo dpkg -i puppet7-release-focal.deb

sudo apt update
sudo apt install puppet-agent

sudo /opt/puppetlabs/bin/puppet apply --modulepath modules/ manifests/site.pp