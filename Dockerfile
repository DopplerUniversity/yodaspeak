FROM node:14-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
LABEL maintainer="Ryan Blunden <ryan.blunden@doppler.com>"

# Ensure DNS resolution works everywhere
# See https://github.com/gliderlabs/docker-alpine/issues/539#issuecomment-607159184
RUN apk add --no-cache bind-tools

# Install the Doppler CLI
RUN (curl -Ls https://cli.doppler.com/install.sh || wget -qO- https://cli.doppler.com/install.sh) | sh

WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm clean-install --only=production --silent --no-audit && mv node_modules ../
COPY . .

USER node

EXPOSE 3000

HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD wget http://localhost:3000/healthz -q -O - > /dev/null 2>&1

# Pass `DOPPLER_TOKEN` at build time to create an encrypted snapshot for high-availability
# Only use for local manual builds for learning and testing purposes
ARG DOPPLER_TOKEN
ENV DOPPLER_TOKEN $DOPPLER_TOKEN
RUN [ -z "$DOPPLER_TOKEN" ] && : || doppler run -- echo "Creating encrypted snapshot fallback"

ENTRYPOINT ["doppler", "run", "--"]
CMD ["npm", "start"]
