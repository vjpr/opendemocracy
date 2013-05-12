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
  law:
    repoPath: '/Users/Vaughan/tmp/main/masterRepo'
    filesPath: '/Users/Vaughan/tmp/main'
