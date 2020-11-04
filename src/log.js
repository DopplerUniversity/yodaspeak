import colors from 'colors'

const log = (message, type = 'info') => {
    switch (type) {
        case 'info':
            console.log(colors.green(`[info]: ${message}`))
            break
        case 'error':
            console.log(colors.red(`[error]: ${message}`))
            break
        default:
            console.log(colors.green(`[${type}]: ${message}`))
    }
}

log.table = obj => {
    let table = []
    Object.keys(obj).forEach(key => {
        let value = obj[key] ? obj[key] : ''
        if (key.match(/KEY|TOKEN|SECRET|CERT/)) {
            value = value.length > 0 ? '*'.repeat(12) : ''
        }
        table.push({ KEY: key, VALUE: value })
    })
    console.table(table)
}

export default log
