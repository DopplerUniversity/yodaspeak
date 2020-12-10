#!/usr/bin/env bash

doppler secrets download --no-file --format env > .env;
docker-compose -f docker-compose.yml --env-file .env up;
rm .env;
docker-compose rm -fsv;
