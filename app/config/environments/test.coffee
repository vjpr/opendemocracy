module.exports = (config) ->
  app:
    port: 9999
    url: "http://localhost.#{config.appName}.herokuapp.com:9999"
  assets:
    remoteAssetsUrl: "/"
    expandTags: false
    usePrecompiledAssets: true
    inPageErrorVerbosity: 'dev'
