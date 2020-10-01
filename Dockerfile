FROM node:14-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
LABEL maintainer="Ryan Blunden <ryan.blunden@ext.doppler.com>"

# Must be supplied at runtime in order for Docker to retrieve secrets
ENV DOPPLER_TOKEN ${DOPPLER_TOKEN}

# Install the Doppler CLI
RUN wget -qO- https://cli.doppler.com/install.sh | sh

WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm clean-install --only=production --silent --no-audit && mv node_modules ../
COPY . .

USER node

CMD ["doppler", "run", "--", "npm", "start"]
