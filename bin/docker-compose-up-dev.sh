#!/usr/bin/env bash

doppler run -- docker-compose -f docker-compose.yml -f docker-compose.dev.yml up;
docker-compose rm -fsv;

