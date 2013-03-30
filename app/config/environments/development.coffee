module.exports = (config) ->
  app:
    port: config.port
    url: "http://localhost.#{config.appName}.herokuapp.com:#{config.port}"
    tryOtherPortsIfInUse: true
  assets:
    remoteAssetsUrl: "/"
