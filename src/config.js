import fs from 'fs'
import dotenv from 'dotenv'
import colors from 'colors'
import awsParamStore from './config/aws_param_store.js'

let config = {}

if (process.env.DOPPLER_PROJECT || process.env.DOPPLER_ENCLAVE_PROJECT) {
    console.log(colors.green('[info]: Using Doppler for config'))
} else if (fs.existsSync('.env')) {
    console.log(colors.green('[info]: .env file found, using for config. You should be using Doppler!'))
    dotenv.config()
}

// Check for AWS Param Store usage
if (awsParamStore.isActive()) {
    console.log(
        colors.green(
            '[info]: Using Doppler AWS Param Store integration for config',
            `prefix: ${process.env.AWS_SSM_PREFIX}`,
            `region: ${process.env.AWS_SSM_REGION}`
        )
    )
    config = {
        LOGGING: awsParamStore.get('LOGGING'),
        HOSTNAME: awsParamStore.get('HOSTNAME'),
        PORT: awsParamStore.get('PORT'),
        TRANSLATE_ENDPOINT: awsParamStore.get('TRANSLATE_ENDPOINT') || '/translate',
        TLS_CERT: awsParamStore.get('TLS_CERT'),
        TLS_KEY: awsParamStore.get('TLS_KEY'),
        TLS_PORT: awsParamStore.get('TLS_PORT'),
        TRANSLATION_SUGGESTION: awsParamStore.get('TRANSLATION_SUGGESTION'),
        YODA_TRANSLATE_API_ENDPOINT: awsParamStore.get('YODA_TRANSLATE_API_ENDPOINT'),
        YODA_TRANSLATE_API_KEY: awsParamStore.get('YODA_TRANSLATE_API_KEY'),
        RATE_LIMITING_ENABLED: awsParamStore.get('RATE_LIMITING_ENABLED') === 'true' ? true : false,
    }
} else {
    config = {
        LOGGING: process.env.LOGGING,
        HOSTNAME: process.env.HOSTNAME,
        PORT: process.env.PORT,
        TRANSLATE_ENDPOINT: process.env.TRANSLATE_ENDPOINT || '/translate', // Can be customized for static site deploys
        TLS_CERT: process.env.TLS_CERT,
        TLS_KEY: process.env.TLS_KEY,
        TLS_PORT: process.env.TLS_PORT,
        TRANSLATION_SUGGESTION: process.env.TRANSLATION_SUGGESTION,
        YODA_TRANSLATE_API_ENDPOINT: process.env.YODA_TRANSLATE_API_ENDPOINT,
        YODA_TRANSLATE_API_KEY: process.env.YODA_TRANSLATE_API_KEY,
        RATE_LIMITING_ENABLED: process.env.RATE_LIMITING_ENABLED === 'true' ? true : false,
    }
}

Object.freeze(config)

export default config
