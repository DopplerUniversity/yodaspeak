import http from 'http'
import https from 'https'
import colors from 'colors'
import config from './config.js'
import app from './app.js'
;(async () => {
    let httpServer, httpsServer
    const appConfig = await config.fetch()
    const HOST = appConfig.HOSTNAME || '0.0.0.0'
    const PORT = appConfig.PORT || 3000

    const onShutdown = code => {
        console.log(colors.green(`\n[info]: Received "${code}"`))
        console.log(colors.green(`[info]: Shutting down HTTP server`))
        httpServer.close()

        if (httpsServer) {
            console.log(colors.green(`[info]: Shutting down HTTPS server`))
            httpsServer.close()
        }
    }

    httpServer = http.createServer(app).listen(PORT, HOST, () => {
        console.log(colors.green(`[info]: HTTP server at http://${HOST}:${PORT}/ (Press CTRL+C to quit)`))
    })

    if (appConfig.TLS_PORT && appConfig.TLS_CERT) {
        httpsServer = https
            .createServer(
                {
                    cert: appConfig.TLS_CERT,
                    key: appConfig.TLS_KEY,
                },
                app
            )
            .listen(appConfig.TLS_PORT, HOST, () => {
                console.log(
                    colors.green(
                        `[info]: HTTPS server at https://${HOST}:${appConfig.TLS_PORT}/ (Press CTRL+C to quit)`
                    )
                )
            })
    }

    process.on('SIGINT', onShutdown)
    process.on('SIGTERM', onShutdown)
})()
