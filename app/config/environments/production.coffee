module.exports = (config) ->
  app:
    port: process.env.PORT
    url: config.deployUrl or "http://#{config.appName}.herokuapp.com"
  assets:
    remoteAssetsUrl: "http://#{config.appName}.s3-website-ap-southeast-2.amazonaws.com/"
