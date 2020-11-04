import log from './log.js'
import env from './config/env.js'
import spawn from 'child_process'
import awsParamStore from './config/aws-param-store.js'
import awsSecretsManager from './config/aws-secrets-manager.js'

let config = null

const setConfig = newConfig => {
    config = newConfig
    if (process.env.DOPPLER_PROJECT) {
        log(`Doppler used for configuration: ${process.env.DOPPLER_PROJECT} > ${process.env.DOPPLER_CONFIG}`)
    }

    log('App Config')
    log.table(config)

    return config
}

const getConfig = async () => {
    if (config) {
        return config
    }

    if (awsParamStore.isActive()) {
        log(`Using Doppler AWS Param Store integration: ${process.env.AWS_SSM_PREFIX} > ${process.env.AWS_SSM_REGION}`)
        return setConfig(Object.freeze(awsParamStore.getConfig()))
    }

    if (awsSecretsManager.isActive()) {
        log(
            `Using Doppler AWS Secrets Manager integration: ${process.env.AWS_SECRETS_MANAGER_KEY} > ${process.env.AWS_SECRETS_MANAGER_REGION}`
        )
        return setConfig(Object.freeze(awsSecretsManager.getConfig()))
    }

    // Catch-all
    return setConfig(Object.freeze(env.getConfig()))
}

export default getConfig
