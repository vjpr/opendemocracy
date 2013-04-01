logger = require('onelog').get 'Assets'
mincerLogger = require('onelog').get 'Assets:Mincer'
Assets = require 'live-assets'
jadeMultiEngine = require './jadeMultiEngine'

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
    mincerLogger: mincerLogger
    inPageErrorVerbosity: if @get('env') is 'production' then 'prod' else 'dev'
    afterEnvironmentCreated: ->
      @env.registerEngine '.mjade', jadeMultiEngine

  # In development/test, precompile on every HTML request.
  switch @app.get('env')
    when 'development', 'test'
      @use (req, res, next) ->
        isHTMLRequest = req.accepted[0]?.value is 'text/html'
        if isHTMLRequest
          assets.precompileForDevelopment (err) ->
            return next err if err
            next()
        else
          next()

  assets.middleware @app
