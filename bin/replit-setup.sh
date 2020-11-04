#!/bin/sh

# Configures a Repl.it environment
# Usage: . ./bin/replit-setup.sh

echo '[info]: Configure $PATH to include npm bin for Node override'
export PATH=$(npm bin):$PATH

echo '[info]: Installing Node.js 14'
npm install node@14
node --version

echo '[info]: Installing Doppler CLI'
(curl -Ls https://cli.doppler.com/install.sh || wget -qO- https://cli.doppler.com/install.sh) | sh -s -- --no-install --no-package-manager
mv doppler $(npm bin)
doppler --version

echo '[info]: Installing Node dependencies'
npm install

echo '[info]: Configuring Doppler'
echo '[info]: Create your free Doppler account at https://dashboard.doppler.com/register'
read -p 'Enter Doppler Service Token for yodaspeak project: ' doppler_token
doppler setup --silent --token $doppler_token
doppler configs

echo '[info]: Repl.it environment configured!'
echo '[info]: You can now start the server with `./bin/replit-start.sh`'
