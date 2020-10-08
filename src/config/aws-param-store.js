import colors from 'colors'
import awsParamStore from 'aws-param-store'

const isActive = () =>
    process.env.AWS_SSM_ENABLED === 'true' && process.env.AWS_SSM_PREFIX && process.env.AWS_SSM_REGION

const get = key => {
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
        LOGGING: get('LOGGING'),
        HOSTNAME: get('HOSTNAME'),
        PORT: get('PORT'),
        TRANSLATE_ENDPOINT: get('TRANSLATE_ENDPOINT') || '/translate',
        TLS_CERT: get('TLS_CERT'),
        TLS_KEY: get('TLS_KEY'),
        TLS_PORT: get('TLS_PORT'),
        TRANSLATION_SUGGESTION: get('TRANSLATION_SUGGESTION'),
        YODA_TRANSLATE_API_ENDPOINT: get('YODA_TRANSLATE_API_ENDPOINT'),
        YODA_TRANSLATE_API_KEY: get('YODA_TRANSLATE_API_KEY'),
        RATE_LIMITING_ENABLED: get('RATE_LIMITING_ENABLED') === 'true' ? true : false,
    }
}

const api = { isActive, getConfig, get }

export default api
