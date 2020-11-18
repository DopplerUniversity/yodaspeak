import http from 'http'
import https from 'https'
import log from './log.js'
import getConfig from './config.js'
import getApp from './app.js'
;(async () => {
    let httpServer, httpsServer
    const config = await getConfig()
    const app = getApp(config)

    const onShutdown = code => {
        log(`\nReceived "${code}"`)
        log(`Shutting down HTTP server`)
        httpServer.close()

        if (httpsServer) {
            log(`Shutting down HTTPS server`)
            httpsServer.close()
        }
    }

    httpServer = http.createServer(app).listen(config.PORT, config.HOSTNAME, () => {
        log(`HTTP server at http://${config.HOSTNAME}:${config.PORT}/ (Press CTRL+C to quit)`)
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
            .listen(config.TLS_PORT, config.HOSTNAME, () => {
                log(`HTTPS server at https://${config.HOSTNAME}:${config.TLS_PORT}/ (Press CTRL+C to quit)`)
            })
    }

    process.on('SIGINT', onShutdown)
    process.on('SIGTERM', onShutdown)
})()
