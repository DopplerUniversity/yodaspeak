import colors from 'colors'
import awsParamStore from 'aws-param-store'

const isActive = () =>
    process.env.AWS_SSM_ENABLED === 'true' && process.env.AWS_SSM_PREFIX && process.env.AWS_SSM_REGION

const getValue = key => {
    try {
        return awsParamStore.getParameterSync(`${process.env.AWS_SSM_PREFIX}${key}`, {
            region: process.env.AWS_SSM_REGION,
        }).Value
    } catch (err) {
        console.error(
            colors.yellow(
                `[warning]: AWS Param Store: Failed to fetch key "${process.env.AWS_SSM_PREFIX}${key}" in region "${process.env.AWS_SSM_REGION}"`
            )
        )
        console.error(colors.yellow(err))
        return ''
    }
}

const getConfig = () => {
    return {
        LOGGING: getValue('LOGGING'),
        HOSTNAME: getValue('HOSTNAME'),
        PORT: getValue('PORT'),
        TRANSLATE_ENDPOINT: getValue('TRANSLATE_ENDPOINT') || '/translate',
        TLS_CERT: getValue('TLS_CERT'),
        TLS_KEY: getValue('TLS_KEY'),
        TLS_PORT: getValue('TLS_PORT'),
        TRANSLATION_SUGGESTION: getValue('TRANSLATION_SUGGESTION'),
        YODA_TRANSLATE_API_ENDPOINT: getValue('YODA_TRANSLATE_API_ENDPOINT'),
        YODA_TRANSLATE_API_KEY: getValue('YODA_TRANSLATE_API_KEY'),
        RATE_LIMITING_ENABLED: getValue('RATE_LIMITING_ENABLED') === 'true' ? true : false,
    }
}

const api = { isActive, getConfig }

export default api
