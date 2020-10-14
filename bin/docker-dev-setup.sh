#!/usr/bin/env sh

echo '[info]: Configuring container for development'
apk add make
echo '[info]: Installing development dependencies'
cp package.json -f ../
cd ../
npm install --only=dev && cd ./app
export PATH=$PATH:/usr/src/node_modules/.bin
echo '[info]: Development environment configured'
