import http from 'http'
import https from 'https'
import colors from 'colors'
import config from './config.js'
import app from './app.js'
;(async () => {
    let httpServer, httpsServer
    const appConfig = await config.fetch()

    httpServer = http.createServer(app).listen(appConfig.PORT, appConfig.HOSTNAME, () => {
        console.log(
            colors.green(
                `[info]: HTTP server at http://${appConfig.HOSTNAME}:${appConfig.PORT}/ (Press CTRL+C to quit)`
            )
        )
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
            .listen(appConfig.TLS_PORT, appConfig.HOSTNAME, () => {
                console.log(
                    colors.green(
                        `[info]: HTTPS server at https://${appConfig.HOSTNAME}:${appConfig.TLS_PORT}/ (Press CTRL+C to quit)`
                    )
                )
            })
    }

    process.on('SIGINT', () => {
        console.log(colors.green(`\n[info]: Shutting down HTTP server`))
        httpServer.close()

        if (httpsServer) {
            console.log(colors.green(`[info]: Shutting down HTTPS server`))
            httpsServer.close()
        }
    })
})()
