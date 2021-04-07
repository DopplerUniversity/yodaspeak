#!/usr/bin/env bash

DOPPLER_TOKEN="$(doppler configure get token --plain)" \
DOPPLER_PROJECT="$(doppler configure get project --plain)" \
DOPPLER_CONFIG="$(doppler configure get config --plain)" \
\
SERVICE_TOKEN=$(curl -sS --request POST \
  --url https://api.doppler.com/v3/configs/config/tokens \
  --header 'Content-Type: application/json' \
  --header "api-key: $DOPPLER_TOKEN" \
  --data "{\"project\":\"$DOPPLER_PROJECT\",\"config\":\"$DOPPLER_CONFIG\",\"name\":\"$DOPPLER_PROJECT VS Code Dev Container\"}" | jq -r '.token.key')

  echo "DOPPLER_TOKEN=$SERVICE_TOKEN" > .devcontainer/.env
