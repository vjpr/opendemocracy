module.exports = (config) ->
  app:
    port: process.env.PORT
    url: url or "http://#{config.appName}.herokuapp.com"
  assets:
    remoteAssetsUrl: "http://#{config.appName}.s3-website-ap-southeast-2.amazonaws.com/"
