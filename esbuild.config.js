// esbuild.config.js
const path = require('path')
const rails = require('esbuild-rails')
const esbuild = require('esbuild')

const watch = process.argv.includes('--watch')

// Configuración base
const baseConfig = {
    bundle: true,
    outdir: path.join(process.cwd(), "app/assets/builds"),
    absWorkingDir: path.join(process.cwd(), "app/javascript"),
    plugins: [rails()],
}

// Múltiples entry points
const entryPoints = ["application.js", "admin.js"]

const config = {
    ...baseConfig,
    entryPoints,
}

if (watch) {
    esbuild.context(config).then(context => {
        context.watch().then(() => {
            console.log('👀 Watching for changes...')
        })
    }).catch(() => process.exit(1))
} else {
    esbuild.build(config).catch(() => process.exit(1))
}