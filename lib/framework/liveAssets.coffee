logger = require('onelog').get 'Assets'
Assets = require 'live-assets'

module.exports = ->
  assets = new Assets
    paths: [
      'assets/app/js'
      'assets/app/css'
      'assets/vendor/js'
      'assets/vendor/css'
      'assets/components'
      'test/client/app'
      'test/client/vendor'
    ]
    digest: false
    expandTags: if @get('env') is 'production' then false else true
    assetServePath: '/assets/'
    remoteAssetsDir: @config.assets.remoteAssetsUrl
    # TODO: Change last word to false.
    usePrecompiledAssets: if @get('env') is 'production' then true else false
    root: process.cwd()
    # Add more files to this array when you need to require them from a template.
    files: [
      'application.js'
      'style.css'
      'admin.js'
      'admin.css'
      'test.js'
      'test.css'
    ]
    logger: logger

  # In development, precompile on every HTML request.
  @configure 'development', =>
    @use (req, res, next) ->
      isHTMLRequest = req.accepted[0].value is 'text/html'
      if isHTMLRequest
        assets.precompileForDevelopment -> next()
      else
        next()

  assets.middleware @app
