import https from 'https'
import cors from 'cors'
import axios from 'axios'
import express from 'express'
import rateLimit from 'express-rate-limit'
import colors from 'colors'
import config from './config.js'

const app = express()
const router = express.Router()
const PREDEFINED_TRANSLATIONS = {
    'Secrets must not be stored in git repositories': 'Stored in git repositories, secrets must not be',
    'master obi-wan has learnt the power of secrets management':
        'Learnt the power of secrets management, master obi-wan has',
}

;(async () => {
    const appConfig = await config.fetch()

    if (appConfig.RATE_LIMITING_ENABLED) {
        console.log(colors.green('[info]: Rate limiting enabled'))
    }
    const translationLimiter = rateLimit({
        windowMs: 60 * 60 * 1000,
        max: appConfig.RATE_LIMITING_ENABLED ? 60 : 0,
        handler: (req, res) => {
            res.json({
                text: req.body.text,
                translation: 'Request too many translation, you have. Try in an hour, you must.',
            })
        },
    })

    router.get('/', (req, res) => {
        res.render('index', {
            translationEndpoint: appConfig.TRANSLATE_ENDPOINT,
            translationSuggestion: appConfig.TRANSLATION_SUGGESTION,
        })
    })

    router.get('/healthz', (req, res) => {
        res.send('Healthy, this server is.')
    })

    router.post('/translate', cors(), translationLimiter, (req, res) => {
        console.log(colors.green(`[info]: Tranlsate text "${req.body.text}"`))

        // Predefined translations help showcase the app without an API key
        const predefinedTranslation = PREDEFINED_TRANSLATIONS[req.body.text.trim()]
        if (predefinedTranslation) {
            console.log(colors.green(`[info]: Translation returned from predefined list`))
            return setTimeout(
                () =>
                    res.json({
                        text: req.body.text,
                        translation: predefinedTranslation,
                    }),
                1000
            )
        }

        ;(async () => {
            try {
                const response = await axios.post(appConfig.YODA_TRANSLATE_API_ENDPOINT, `text=${req.body.text}`, {
                    headers: {
                        'X-Funtranslations-Api-Secret': appConfig.YODA_TRANSLATE_API_KEY,
                    },
                })
                res.json({
                    text: req.body.text,
                    translation: response.data.contents.translated,
                })
            } catch (error) {
                console.log(colors.red(`[error]: translation failed: ${error.response.data.error.message}`))
                res.status(500).json({
                    text: req.body.text,
                    error: 'Sorry, am I, as translate your message, I cannot.',
                })
            }
        })()
    })
})()
export default router
