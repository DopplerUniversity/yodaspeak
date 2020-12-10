#!/usr/bin/env bash

# Runs as root user in order to install dev packages
docker container run \
-it \
--init \
--rm \
--name yodaspeak \
-v $(pwd):/usr/src/app:cached \
-u root \
--env-file <(doppler secrets download --no-file --format docker) \
-p 8443:8443 \
-p 8080:8080 \
dopplerhq/yodaspeak:latest ./bin/docker-dev-cmd.sh
