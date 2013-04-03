module.exports = (config) ->
  app:
    port: process.env.PORT or 3030
    url: config.deployUrl or "http://#{config.appName}.herokuapp.com"
  assets:
    #remoteAssetsUrl: "http://#{config.appName}.s3-website-ap-southeast-2.amazonaws.com/"
    remoteAssetsUrl: "http://#{config.appName}.herokuapp.com/"
    expandTags: false
    usePrecompiledAssets: true
    inPageErrorVerbosity: 'prod'
