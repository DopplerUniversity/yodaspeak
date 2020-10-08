import colors from 'colors'
import awsParamStore from 'aws-param-store'

const isActive = () =>
    process.env.AWS_SSM_ENABLED === 'true' && process.env.AWS_SSM_PREFIX && process.env.AWS_SSM_REGION

const awsParamStoreGet = key => {
    try {
        return awsParamStore.getParameterSync(`${process.env.AWS_SSM_PREFIX}${key}`, {
            region: process.env.AWS_SSM_REGION,
        }).Value
    } catch (err) {
        console.error(
            colors.yellow(
                `[warning]: AWS Param Store: Failed to fetch key "${key}" in region "${process.env.AWS_SSM_REGION}"`
            )
        )
        console.error(colors.yellow(err))
        return ''
    }
}

const api = {
    isActive,
    get: awsParamStoreGet,
}

export default api
