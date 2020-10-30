import exec from 'child_process'
import path from 'path'
import http from 'http'
import express from 'express'
import log from './log.js'

log('Building static site')
exec.execSync('npm run build-static')

const app = express()
const staticDir = `${path.dirname(new URL(import.meta.url).pathname)}/../dist`
const HOST = process.env.HOSTNAME || 'localhost'
const PORT = process.env.PORT || 3333
app.use(express.static(staticDir))

http.createServer(app).listen(PORT, HOST, () => {
    log(`Static HTTP server at http://${HOST}:${PORT}/ (Press CTRL+C to quit)`)
})
