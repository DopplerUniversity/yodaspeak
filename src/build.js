import fs from 'fs'
import ncp from 'ncp'
import nunjucks from 'nunjucks'
import log from './log.js'

const DIST_DIR = './dist'
const TRANSLATE_ENDPOINT = process.env.TRANSLATE_ENDPOINT
const TRANSLATION_SUGGESTION = process.env.TRANSLATION_SUGGESTION

nunjucks.configure('src/views', {
    autoescape: true,
})

if (fs.existsSync(DIST_DIR)) {
    fs.rmdirSync(DIST_DIR, { recursive: true })
}
fs.mkdirSync(DIST_DIR)

fs.writeFileSync(
    'dist/index.html',
    nunjucks.render('index.nunjucks', {
        translationEndpoint: TRANSLATE_ENDPOINT,
        translationSuggestion: TRANSLATION_SUGGESTION,
    })
)

ncp('./src/public', DIST_DIR, function (err) {
    if (err) {
        return console.error(err)
    }

    log(`Static files saved to ${DIST_DIR}`)
})
