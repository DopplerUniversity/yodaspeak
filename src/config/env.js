import fs from 'fs'
import dotenv from 'dotenv'
import log from '../log.js'

const getConfig = () => {
    if (fs.existsSync('.env')) {
        log('Config supplied by .env file')
        dotenv.config()
    }

    return {
        LOGGING: process.env.LOGGING,
        HOSTNAME: process.env.HOSTNAME,
        PORT: process.env.PORT || 8080,
        TRANSLATE_ENDPOINT: process.env.TRANSLATE_ENDPOINT || '/translate', // Set to remote URL for static site deploys
        TLS_CERT: process.env.TLS_CERT || '',
        TLS_KEY: process.env.TLS_KEY || '',
        TLS_PORT: process.env.TLS_PORT || 8443,
        TRANSLATION_SUGGESTION: process.env.TRANSLATION_SUGGESTION,
        YODA_TRANSLATE_API_ENDPOINT: process.env.YODA_TRANSLATE_API_ENDPOINT,
        YODA_TRANSLATE_API_KEY: process.env.YODA_TRANSLATE_API_KEY,
        RATE_LIMITING_ENABLED: process.env.RATE_LIMITING_ENABLED === 'true' ? true : false,
    }
}

export default { getConfig }
