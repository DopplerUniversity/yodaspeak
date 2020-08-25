#!/usr/bin/env bash

export HOME=/root
export PATH=$PATH:/usr/local/bin
export PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
export IP_ADDRESS=$(echo $(hostname -I) | awk '{print $1;}')
export DOPPLER_TOKEN="${service_token}"

# Add Doppler's yum repo
wget https://bintray.com/dopplerhq/doppler-rpm/rpm -O /etc/yum.repos.d/bintray-dopplerhq-doppler.repo

# Add Node.js yum repo
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -

yum clean all
yum update -y
yum upgrade -y

yum install -y \
    git \
    nano \
    gcc-c++ \
    make \
    nodejs \
    doppler

# Setup app
git clone https://github.com/DopplerHQ/you-speak-yoda.git /usr/src/app
cd /usr/src/app
npm install
doppler enclave setup --no-prompt
make prod-server-up
