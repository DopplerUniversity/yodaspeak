#!/usr/bin/env bash

docker container run \
--init \
-d \
--restart unless-stopped \
--name yodaspeak \
--env-file <(doppler secrets download --no-file --format docker) \
-p 8443:8443 \
-p 8080:8080 \
dopplerhq/yodaspeak:latest
