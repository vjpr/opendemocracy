module.exports = (config) ->
  app:
    port: config.port
    url: "http://localhost.#{config.appName}.com.au:#{config.port}"
    tryOtherPortsIfInUse: true
  assets:
    remoteAssetsUrl: "/"
    expandTags: true
    usePrecompiledAssets: false
    inPageErrorVerbosity: 'dev'
