import AWS from 'aws-sdk'
import colors from 'colors'

var secretsManager = new AWS.SecretsManager({
    region: process.env.AWS_SECRETS_MANAGER_REGION,
})

const isActive = () =>
    process.env.AWS_SECRETS_MANAGER_ENABLED === 'true' &&
    process.env.AWS_SECRETS_MANAGER_KEY &&
    process.env.AWS_SECRETS_MANAGER_REGION

const getConfig = async () => {
    try {
        const data = await secretsManager
            .getSecretValue({
                SecretId: process.env.AWS_SECRETS_MANAGER_KEY,
            })
            .promise()

        if (data && data.SecretString) {
            if (data.SecretString) {
                return JSON.parse(data.SecretString)
            }
        }
    } catch (error) {
        console.log(colors.red('[error]: AWS Secrets Manager: Error retrieving secrets'))
        console.log(colors.red(error))
    }
}

const api = { isActive, getConfig }

export default api
