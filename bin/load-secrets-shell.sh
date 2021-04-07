#! /usr/bin/env bash

# Loads Doppler environment variables into the current shell

# usage: . ./bin/load-secrets-shell.sh

set -a
eval $(doppler secrets download --no-file --format env)
set +a