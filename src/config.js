import fs from 'fs'
import dotenv from 'dotenv'
import log from './log.js'
import env from './config/env.js'
import awsParamStore from './config/aws-param-store.js'
import awsSecretsManager from './config/aws-secrets-manager.js'

let config = null

const getConfig = async () => {
    if (config) {
        return config
    }

    if (process.env.DOPPLER_PROJECT || process.env.DOPPLER_ENCLAVE_PROJECT) {
        log(`Doppler environment detected: ${process.env.DOPPLER_PROJECT} > ${process.env.DOPPLER_CONFIG}`)
    }

    if (awsParamStore.isActive()) {
        log(`Using Doppler AWS Param Store integration: ${process.env.AWS_SSM_PREFIX} > ${process.env.AWS_SSM_REGION}`)
        config = Object.freeze(awsParamStore.getConfig())
        return config
    }

    if (awsSecretsManager.isActive()) {
        log(
            `Using Doppler AWS Secrets Manager integration: ${process.env.AWS_SECRETS_MANAGER_KEY} > ${process.env.AWS_SECRETS_MANAGER_REGION}`
        )
        config = Object.freeze(awsSecretsManager.getConfig())
        return config
    }

    // Catch-all
    config = Object.freeze(env.getConfig())
    return config
}

export default getConfig
