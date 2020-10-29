import fs from 'fs'
import ncp from 'ncp'
import colors from 'colors'
import nunjucks from 'nunjucks'
import config from './config.js'
import log from './log.js'

const DIST_DIR = './dist'

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
        translationEndpoint: config.TRANSLATE_ENDPOINT,
        translationSuggestion: config.TRANSLATION_SUGGESTION,
    })
)

ncp('./src/public', DIST_DIR, function (err) {
    if (err) {
        return console.error(err)
    }

    log(`Static files saved to ${DIST_DIR}`)
})
