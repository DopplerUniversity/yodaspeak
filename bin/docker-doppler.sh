#!/usr/bin/env bash

# Requires `DOPPLER_TOKEN` env var to be set
docker container run \
--init \
-d \
--restart unless-stopped \
--name yodaspeak \
-e DOPPLER_TOKEN=${DOPPLER_TOKEN} \
-p 8443:8443 \
-p 8080:8080 \
dopplerhq/yodaspeak:latest doppler run -- npm start
