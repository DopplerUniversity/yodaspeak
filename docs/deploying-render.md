# Deploying on Render

Follow these instructions to get YodaSpeak running on Render as a web application.

## Configuring Doppler

1. Create a new project called `yodaspeak`
2. Go to **prd** and upload the contents of the [sample.env](../sample.env) file
3. Alter the secret values accordingly:
  - Change `HOSTNAME` to be `0.0.0.0`
  - Change `LOGGING` to `common`
  - Change `NODE_ENV` to `production`
  - Delete `PORT`
4. Click **Save** to save your secrets

Now we need to create a service token that we'll use in Render:

1. Ensuring you are still viewing your secrets for YodaSpeak in the **prd** environment, click on the **Acess** tab
2. Create a **Service Token**, naming it **Render**
3. Copy the service token to your clipboard as you'll need it for configuring Render

## Configuring Render

<!-- todo(ryan): Remove `doppler-cloud-install-standalone` and `./doppler` once Render have updated the CLI to be v3.13.0 or greater -->

We will configure Doppler on Render to use a [Doppler Service Token](https://docs.doppler.com/docs/enclave-service-tokens).

The `doppler` commands below set the`.doppler.yaml` config file to reside in the repository root, so it is bundled with our application payload.

To configure Render:

1. Log into Render
2. Create a new app with a unique name using `https://github.com/dopplerhq/yodaspeak` as the repository
3. Set the **Build Command** to be:
```
npm run doppler-cloud-install-standalone; ./doppler setup --no-prompt --silent --configuration .doppler.yaml; npm install --production;
```
4. Set the **Start Command** to be:
```
./doppler run --configuration .doppler.yaml -- npm start;
```
5. Set the **Health Check Path** to be `/healthz`
6. Create the app

Now you need to configure the application with a single environment variable that contains the [Doppler Service Token](https://docs.doppler.com/docs/enclave-service-tokens):

1. Click on the **Environment** tab
2. Create a new variable with key name `DOPPLER_TOKEN` and the value being the service token you copied earlier
3. Click **Save Changes**

## Deploy your site using Doppler for configuration

The final step is to apply these changes by triggering a **Manual Deploy**, selecting **Clear build cache and deploy**. This manual deploy is required as Render does not automatically re-deploy your application when the environment variables change.

## Viewing your deployed site

Once the manual deploy has completed, you should now be able to access the YodaSpeak application at the Render provided URL.
