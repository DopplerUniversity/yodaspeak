FROM node:14

LABEL maintainer="Ryan Blunden <ryan.blunden@ext.doppler.com>"

# DOPPLER_TOKEN must be supplied as a build-arg
ARG DOPPLER_TOKEN
ENV DOPPLER_TOKEN ${DOPPLER_TOKEN}

# Install the Doppler CLI
RUN curl -Ls https://cli.doppler.com/install.sh | sh

# Execute `doppler run` so it creates a secrets fallback file
RUN doppler run -- echo "Create secrets fallback file"

WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "src", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .

CMD ["doppler", "run", "--", "npm", "start"]
