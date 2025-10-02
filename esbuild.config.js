const path = require('path')
const rails = require('esbuild-rails')
const esbuild = require('esbuild')

const watch = process.argv.includes('--watch')
const config = {
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  plugins: [rails()],
}

if (watch) {
  esbuild.context(config).then(context => {
    context.watch().then(() => {
      console.log('watching for changes...')
    })
  }).catch(() => process.exit(1))
} else {
  esbuild.build(config).catch(() => process.exit(1))
}
