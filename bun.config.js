await Bun.build({
  entrypoints: ['./app/assets/javascripts/components/has_secure_passkey.js'],
  outdir: './app/assets/javascripts/',
  external: ["HTMLElement"]
})
