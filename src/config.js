import fs from 'fs'
import dotenv from 'dotenv'
import colors from 'colors'
import awsParamStore from 'aws-param-store'

// Helper functions
const awsParamStoreGet = key => {
    try {
        return awsParamStore.getParameterSync(`${process.env.AWS_SSM_PREFIX}${key}`, {
            region: process.env.AWS_SSM_REGION,
        }).Value
    }
    catch(err) {
        console.error(colors.yellow(`[warning]: AWS Param Store: Failed to fetch key "${key}" in region "${process.env.AWS_SSM_REGION}"`))
        console.error(colors.yellow(err))
        return ''
    }
}

let config = {}

if (process.env.DOPPLER_PROJECT || process.env.DOPPLER_ENCLAVE_PROJECT) {
    console.log(colors.green('[info]: Using Doppler for config'))
} else if (fs.existsSync('.env')) {
    console.log(colors.green('[info]: .env file found, using for config. You should be using Doppler!'))
    dotenv.config()
}

// Check for AWS Systems Manager Param Store usage
if (process.env.AWS_SSM_ENABLED === 'true' && process.env.AWS_SSM_PREFIX && process.env.AWS_SSM_REGION) {
    console.log(
        colors.green(
            '[info]: Using Doppler AWS Systems Manager Param Store integration for config',
            `prefix: ${process.env.AWS_SSM_PREFIX}`,
            `region: ${process.env.AWS_SSM_REGION}`
        )
    )
    config = {
        LOGGING: awsParamStoreGet('LOGGING'),
        HOSTNAME: awsParamStoreGet('HOSTNAME'),
        PORT: awsParamStoreGet('PORT'),
        TRANSLATE_ENDPOINT: awsParamStoreGet('TRANSLATE_ENDPOINT') || '/translate',
        TLS_CERT: awsParamStoreGet('TLS_CERT'),
        TLS_KEY: awsParamStoreGet('TLS_KEY'),
        TLS_PORT: awsParamStoreGet('TLS_PORT'),
        TRANSLATION_SUGGESTION: awsParamStoreGet('TRANSLATION_SUGGESTION'),
        YODA_TRANSLATE_API_ENDPOINT: awsParamStoreGet('YODA_TRANSLATE_API_ENDPOINT'),
        YODA_TRANSLATE_API_KEY: awsParamStoreGet('YODA_TRANSLATE_API_KEY'),
        RATE_LIMITING_ENABLED: awsParamStoreGet('RATE_LIMITING_ENABLED') === 'true' ? true : false,
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
