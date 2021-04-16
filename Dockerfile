FROM node:lts-alpine

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
LABEL maintainer="Ryan Blunden <ryan.blunden@doppler.com>"

# Use to cache bust system dependencies
ENV LAST_UPDATED 2021-04-16

# Installing bind-tools ensures DNS resolution works everywhere
# See https://github.com/gliderlabs/docker-alpine/issues/539#issuecomment-607159184
RUN apk add --no-cache bind-tools gnupg git

# Doppler CLI
RUN (curl -Ls https://cli.doppler.com/install.sh || wget -qO- https://cli.doppler.com/install.sh) | sh

# Tini for init process management
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

WORKDIR /usr/src/app
ENV PATH=$PATH:/usr/src/app/node_modules/.bin

COPY package.json package-lock.json ./
RUN npm clean-install --only=production --silent --no-audit && mv node_modules ../
COPY . .

USER node

EXPOSE 8080 8443

HEALTHCHECK --interval=5s --timeout=5s --retries=3 CMD wget http://localhost:8080/healthz -q -O - || exit 1

ENTRYPOINT ["tini", "--"]
CMD ["doppler", "run", "--", "node", "src/server.js"]
