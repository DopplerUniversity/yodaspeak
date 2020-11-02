#!/bin/sh

echo '[info]: Ensure you have run `. ./bin/replit-setup.sh` to install and configure all dependencies'

export PATH=$(npm bin):$PATH
doppler run -- npm start
