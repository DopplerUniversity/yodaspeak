import http from 'http'
import https from 'https'
import colors from 'colors'
import config from './config.js'
import app from './app.js'

http.createServer(app).listen(config.PORT, config.HOSTNAME, () => {
    console.log(colors.green(`[info]: HTTP server at http://${config.HOSTNAME}:${config.PORT}/ (Press CTRL+C to quit)`))
})

if (config.TLS_PORT && config.TLS_CERT && config.TLS_PORT) {
    https
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
