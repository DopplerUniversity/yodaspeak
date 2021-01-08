# Yoda Speak

[![](./src/public/img/screenshot.jpg)](https://yodaspeak.io/)

A simple application to translate English into Yoda Speak.

It's designed to show how to use the [Doppler Universal Secrets Manager](https://doppler.com/) for securely and easily fetching app config and secrets for local and production environments using the Doppler CLI and either a system installation of Node.js, Docker, or Docker Compose (Kubernetes coming soon).

New to Doppler? [Check out our documentation](https://docs.doppler.com/docs) to get started with your own applications, or clone this repo and follow-along.

> NOTE: The Yoda translation API used by the app is limited to 5 requests per hour unless you [register to purchase an API key](https://funtranslations.com/register). You can view the production site at [https://yodaspeak.io/](https://yodaspeak.io/)

## Requirements

The commands and scripts to run tha application will work on macOS and Linux variants but not Windows. If you wish to get this working on Windows, either use [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) or create an issue if you'd like to see native Windows support via PowerShell.

Requirements:

- [Doppler CLI](https://docs.doppler.com/docs/enclave-installation)
- Node 14+
- Docker
- Docker Compose

If on macOS, you can install the Doppler CLI by running:

```sh
brew install dopplerhq/cli/doppler node
```

## Doppler set up

1. [Install Doppler](https://docs.doppler.com/docs/enclave-installation)
1. From a terminal, run:

```sh
doppler login
```

1. Once logged in, open a new browser window and [sign in to Doppler](https://dashboard.doppler.com/)
1. In the Doppler Web UI, create a workspace

Once authenticated, run the following command to create the `yodaspeak` project in Doppler and populate the required secrets with default values:

```sh
make doppler-project-setup
```

## Local development with system Node.js

Run `npm start` to install all app dependencies.

Then use `doppler run` to call the `npm start` command, which will inject our secrets as environment variables:

```sh
doppler run -- npm start
```

> NOTE: For HTTPS, create the `TLS_CERT`, `TLS_KEY`, and `TLS_PORT` secrets

## Using Docker

You can use Docker in production using a [Doppler service token](https://docs.doppler.com/docs/enclave-service-tokens) to provide read-only access to a specific production config, or run the container locally local code mounted into the container and the development dependencies installed.

To use Docker in production, run:

```sh
# Requires `DOPPLER_TOKEN` to be exported
make docker
```

For local development, run:

```sh
make docker-dev
```

There are also commands for using Docker Compose.

To use Docker Compose in production, run:

```sh
make docker-compose-up
```

For local development, run:

```sh
make docker-compose-up-dev
```

## Deploying to Heroku

This is mainly for the Doppler team to test the Heroku integration but you can deploy this to your own Heroku account/team, by overriding the default values for:

- `HEROKU_TEAM`
- `HEROKU_APP`
- `DOMAIN`

Creating and deploying a site also consists of setting initial default values for config vars in order for the app to deploy successfully.

Then once the app has deployed, open the Doppler dashboard and enable the Heroku integration for the relevant environment.

To create and deploy to production using default values (works for Doppler team only)

```sh
make heroku-create -f Heroku.Makefile
```

To create and deploy to your own custom account:

```sh
make heroku-create -f Heroku.Makefile HEROKU_TEAM=your-heroku-team HEROKU_APP=your-yodaspeak-app-name DOMAIN=your-domain.yodaspeak.com
```


## Using Repl.it

[![Work in Repl.it](https://classroom.github.com/assets/work-in-replit-14baed9a392b3a25080506f3b7b6d57f295ec2978f6f33ec97e36a161684cbe9.svg)](https://repl.it/github/dopplerhq/yodaspeak)

> NOTE: This is a work in progress and feedback is greatly appreciated!

You can quickly and easily run [YodaSpeak on repl.it](https://repl.it/github/dopplerhq/yodaspeak) by following the below steps once your environment has booted up:

1. Create a [Service Token](https://docs.doppler.com/docs/enclave-service-tokens) and expose it using the `DOPPLER_TOKEN` environment variable
1. Install and configure all required dependencies by running:

```sh
# You'll need to paste your Doppler Service Token when prompted
. ./bin/replit-setup.sh
```

Once setup, you can then start the server by clicking the **Run** button, or manually by running:

```sh
./bin/replit-start.sh
```

## Having trouble?

Create a GitHub issue, including your OS and Node version, and we'll help you out!
