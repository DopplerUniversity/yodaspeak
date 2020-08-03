import https from 'https'
import axios from 'axios'
import express from 'express'
import config from './config.js'

const app = express()
const router = express.Router()

router.get('/', (req, res) => {
    res.render('index', { translationSuggestion: config.TRANSLATION_SUGGESTION })
})

router.post('/translate', (req, res) => {
    console.log(`[info]: tranlsate text "${req.body.text}"`)
    ;(async () => {
        try {
            const response = await axios.post(config.YODA_TRANSLATE_API_ENDPOINT, `text=${req.body.text}`, {
                headers: {
                    'X-Funtranslations-Api-Secret': config.YODA_TRANSLATE_API_KEY,
                },
            })
            res.json({
                text: req.body.text,
                translation: response.data.contents.translated,
            })
        } catch (error) {
            console.log(`[error]: translation failed: ${error.response.data.error.message}`)
            res.status(500).json({ text: req.body.text, error: 'Sorry, am I, as translate your message, I cannot.' })
        }
    })()
})

export default router
