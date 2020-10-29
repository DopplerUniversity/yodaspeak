import express from 'express'
import path from 'path'
import logger from 'morgan'
import cookieParser from 'cookie-parser'
import nunjucks from 'nunjucks'
import getRouter from './router.js'

let app

const getApp = config => {
    if (app) {
        return app
    }

    app = express()
    const __dirname = path.dirname(new URL(import.meta.url).pathname)
    const router = getRouter(config)

    app.set('views', path.join(__dirname, 'views'))
    app.set('view engine', 'nunjucks')
    nunjucks.configure('src/views', {
        autoescape: true,
        express: app,
    })

    app.use(express.json())
    app.use(express.urlencoded({ extended: true }))
    app.use(cookieParser())

    app.use(router)
    app.use(express.static(path.join(__dirname, 'public')))
    app.use(logger(config.LOGGING))

    return app
}

export default getApp
