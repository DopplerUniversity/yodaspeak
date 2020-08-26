#!/usr/bin/env bash

# Required by Doppler
export HOME=/root

# Build system supplies the service token and Git SHA
export DOPPLER_TOKEN="${doppler_service_token}"
export GIT_SHA="${git_sha}"

# Add Doppler yum repo
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

# Set up application
git clone https://github.com/DopplerHQ/you-speak-yoda.git /usr/src/app
cd /usr/src/app
npm install

# Configure Doppler to access secrets using a service token
doppler enclave setup --no-prompt --token $DOPPLER_TOKEN

# Pass secrets as environment vars to our application using `doppler run`
# Run our application in a persistent background process
nohup doppler run -- npm start >/dev/null 2>&1 &
