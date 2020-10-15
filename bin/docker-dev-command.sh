#!/bin/sh
set -e

echo "[info]: Configuring container for development"
echo "[info]: Doppler config: $DOPPLER_PROJECT => $DOPPLER_CONFIG"
echo "[info]: Installing development dependencies"
cp package.json -f ../
cd ../
npm install --only=dev && cd ./app
export PATH=$PATH:/usr/src/node_modules/.bin
echo "[info]: Development environment configured"
echo "[info]: Starting server"
nodemon npm start
