# Yoda Speak

[![](./src/public/img/screenshot.jpg)](https://yodaspeak.io/)

A simple application to translate English into Yoda's version, which is mostly, back to front, or, in other words, [object–subject–verb](https://en.wikipedia.org/wiki/Object%E2%80%93subject%E2%80%93verb) word order.

It's designed to show how to use the [Doppler Universal Secrets Manager](https://doppler.com/) for securely and easily fetching secrets and application configuration via environment variables.

## Requirements

-   [Doppler CLI](https://docs.doppler.com/docs/enclave-installation)
-   Node 14+

If on macOS, you can install these by running:

```sh
brew install dopplerhq/cli/doppler node
```

## Setting up

1. Install dependencies:

```sh
npm install
```

2. Use an `.env` file initially to supply secrets and configuration:

```sh
cp sample.env .env
```

3. Run the server:

```sh
npm start
```

## Running the app using Doppler

1. [Install Doppler](https://docs.doppler.com/docs/enclave-installation)
1. From a terminal, run:

```sh
doppler login
```

1. Once logged in, open a new browser window and [sign in to Doppler](https://dashboard.doppler.com/)
1. In the Doppler Web UI, create a workspace
1. Then [create a project](https://docs.doppler.com/docs/enclave-project-setup) called `yodaspeak`
1. Add the required secrets and configuration by uploading the contents of `sample.env` file, then save.
1. In a terminal, cd into the `yodaspeak` directory, then run:

```sh
# Configure Doppler to fetch the `yodaspeak` secrets from the `dev` config
doppler setup
```

To check that the Doppler CLI can access the project and retrieve its secrets, run:

```sh
doppler run -- printenv YODA
```

If secrets are displayed, Doppler is good to go! Now let's run the server.

> NOTE: The Yoda translation API used by the app is limited to 5 requests per hour unless you [register to purchase an API key](https://funtranslations.com/register). You can view the production site at [https://yodaspeak.io/](https://yodaspeak.io/)

Now let's use `doppler run` to call the `npm start` command, which will inject our secrets as environment variables that our app can use.

```sh
doppler run -- npm start
```

You can now access the site at [http://localhost:3000](http://localhost:3000)

## Using Docker

You can use Docker to run the app in the same way you would in production with a [Doppler service token](https://docs.doppler.com/docs/enclave-service-tokens), or you can configure it the same way you would a local development environment.

> NOTE: If you change the value for `PORT` in Doppler, then you'll need to update the port binding in the `docker container run` command to match. For example, if `PORT` were changed to `8080`, then it would be `-p 8080:8080`.

### Running in production mode with a service token

Using Docker requires a [Doppler service token](https://docs.doppler.com/docs/enclave-service-tokens) for a config populated with the secrets in the [sample.env file](sample.env), as all secrets will be fetched at runtime.

To run the Yoda Speak Docker container, run:

```sh
 docker container run -it --rm -e DOPPLER_TOKEN="dp.st.xxx" -p 3000:3000 dopplerhq/yodaspeak:latest
```

### Running in development mode

To run the Yoda Speak container in development mode, we will execute a shell instead of the `doppler run` command so we can authenticate from and configure Doppler within the container, then start the server manually.

```sh
# Run the container with a shell
docker container run -it --rm -p 3000:3000 dopplerhq/yodaspeak:latest sh
```

> NOTE: All of the below commands are to be executed inside the running container

Now authenticate from within the container:

```sh
# Manually copy the auth code
doppler login
```

Once you've authenticated and created the token for your user, now configure Doppler to access the correct project and config:

```sh
doppler setup
```

Now you're ready to run the server manually:

```sh
doppler run -- npm start
```

You should now be able to access the app from your browser at [http://localhost:3000/](http://localhost:3000/)

## Deploying

Yoda Speak currently has deployment guides for the following platforms:

-   [Render](docs/deploying-render.md)

## Having trouble getting the app working?

Create a GitHub issue, including your OS and Node version, and we'll help you out!
