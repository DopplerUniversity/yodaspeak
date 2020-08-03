import createError from 'http-errors'
import express from 'express'
import path from 'path'
import logger from 'morgan'
import cookieParser from 'cookie-parser'
import nunjucks from 'nunjucks'
import colors from 'colors'

import router from './router.js'
import config from './config.js'

const app = express()
const __dirname = path.dirname(new URL(import.meta.url).pathname)

app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'nunjucks')
nunjucks.configure('src/views', {
    autoescape: true,
    express: app,
})

app.use(logger(config.LOGGING))
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(cookieParser())

app.use(router)
app.use(express.static(path.join(__dirname, 'public')))
app.listen(config.PORT, config.HOSTNAME, () => {
    console.log(colors.green(`[info]: Running on http://${config.HOSTNAME}:${config.PORT}/ (Press CTRL+C to quit)`))
})
