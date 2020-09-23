import http from 'http'
import https from 'https'
import colors from 'colors'
import config from './config.js'
import app from './app.js'

let httpServer, httpsServer

httpServer = http.createServer(app).listen(config.PORT, config.HOSTNAME, () => {
    console.log(colors.green(`[info]: HTTP server at http://${config.HOSTNAME}:${config.PORT}/ (Press CTRL+C to quit)`))
})

if (config.TLS_PORT && config.TLS_CERT && config.TLS_PORT) {
    httpsServer = https
        .createServer(
            {
                cert: config.TLS_CERT,
                key: config.TLS_KEY,
            },
            app
        )
        .listen(config.TLS_PORT, config.HOSTNAME, () => {
            console.log(
                colors.green(
                    `[info]: HTTPS server at https://${config.HOSTNAME}:${config.TLS_PORT}/ (Press CTRL+C to quit)`
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
