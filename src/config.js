import fs from 'fs'
import dotenv from 'dotenv'
import colors from 'colors'

if (process.env.DOPPLER_ENCLAVE_PROJECT) {
    console.log(colors.green('[info]: Using Doppler for config'))
} else if (fs.existsSync('.env')) {
    console.log(colors.green('[info]: .env file found, using for config.'))
    dotenv.config()
} else {
    console.log(colors.red('[error]: No env var configuration found.'))
}

const config = Object.freeze({
    HOSTNAME: process.env.HOSTNAME,
    PORT: process.env.PORT,
    LOGGING: process.env.LOGGING,
    TRANSLATION_SUGGESTION: process.env.TRANSLATION_SUGGESTION,
    YODA_TRANSLATE_API_ENDPOINT: process.env.YODA_TRANSLATE_API_ENDPOINT,
    YODA_TRANSLATE_API_KEY: process.env.YODA_TRANSLATE_API_KEY,
})

export default config
