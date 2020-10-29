import http from 'http'
import https from 'https'
import colors from 'colors'
import log from './log.js'
import getConfig from './config.js'
import getApp from './app.js'
;(async () => {
    let httpServer, httpsServer
    const config = await getConfig()
    const app = getApp(config)
    const HOST = config.HOSTNAME || '0.0.0.0'
    const PORT = config.PORT || 3000

    const onShutdown = code => {
        log(`\nReceived "${code}"`)
        log(`Shutting down HTTP server`)
        httpServer.close()

        if (httpsServer) {
            log(`Shutting down HTTPS server`)
            httpsServer.close()
        }
    }

    httpServer = http.createServer(app).listen(PORT, HOST, () => {
        log(`HTTP server at http://${HOST}:${PORT}/ (Press CTRL+C to quit)`)
    })

    if (config.TLS_PORT && config.TLS_CERT) {
        httpsServer = https
            .createServer(
                {
                    cert: config.TLS_CERT,
                    key: config.TLS_KEY,
                },
                app
            )
            .listen(config.TLS_PORT, HOST, () => {
                log(`HTTPS server at https://${HOST}:${config.TLS_PORT}/ (Press CTRL+C to quit)`)
            })
    }

    process.on('SIGINT', onShutdown)
    process.on('SIGTERM', onShutdown)
})()
