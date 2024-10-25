await Bun.build({
  entrypoints: ['./app/assets/javascripts/components/index.js'],
  outdir: './app/assets/javascripts/build',
  external: ["HTMLElement"]
})
