import fs from 'fs'
import dotenv from 'dotenv'
import colors from 'colors'
import awsParamStore from './config/aws-param-store.js'
import awsSecretsManager from './config/aws-secrets-manager.js'

let config = null

async function fetch() {
    if (config) {
        return config
    }

    if (process.env.DOPPLER_PROJECT || process.env.DOPPLER_ENCLAVE_PROJECT) {
        console.log(
            colors.green(
                `[info]: Doppler environment detected: ${process.env.DOPPLER_PROJECT} > ${process.env.DOPPLER_CONFIG}`
            )
        )
    } else if (fs.existsSync('.env')) {
        console.log(colors.green('[info]: .env file found, using for config. You should be using Doppler!'))
        dotenv.config()
    }

    if (awsParamStore.isActive()) {
        console.log(
            colors.green(
                `[info]: Using Doppler AWS Param Store integration: ${process.env.AWS_SSM_PREFIX} > ${process.env.AWS_SSM_REGION}`
            )
        )
        config = Object.freeze(awsParamStore.getConfig())
        return config
    } else if (awsSecretsManager.isActive()) {
        console.log(
            colors.green(
                `[info]: Using Doppler AWS Secrets Manager integration: ${process.env.AWS_SECRETS_MANAGER_KEY} > ${process.env.AWS_SECRETS_MANAGER_REGION}`
            )
        )
        config = Object.freeze(awsSecretsManager.getConfig())
        return config
    } else {
        console.log(colors.green(`[info]: Using Doppler configured env vars`))
        config = Object.freeze({
            LOGGING: process.env.LOGGING,
            HOSTNAME: process.env.HOSTNAME,
            PORT: process.env.PORT,
            TRANSLATE_ENDPOINT: process.env.TRANSLATE_ENDPOINT || '/translate', // Set to remote URL for static site deploys
            TLS_CERT: process.env.TLS_CERT,
            TLS_KEY: process.env.TLS_KEY,
            TLS_PORT: process.env.TLS_PORT,
            TRANSLATION_SUGGESTION: process.env.TRANSLATION_SUGGESTION,
            YODA_TRANSLATE_API_ENDPOINT: process.env.YODA_TRANSLATE_API_ENDPOINT,
            YODA_TRANSLATE_API_KEY: process.env.YODA_TRANSLATE_API_KEY,
            RATE_LIMITING_ENABLED: process.env.RATE_LIMITING_ENABLED === 'true' ? true : false,
        })

        return config
    }
}

export default { fetch }
