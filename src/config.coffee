_ = require 'underscore'

config = null

module.exports = (env) ->

  return config if config?

  appName = "expressbootstrap" # TODO

  url = null # TODO

  port = 3030

  envs =
    development:
      app:
        port: port
        url: "http://localhost.#{appName}.herokuapp.com:#{port}"
      mongo:
        url: "mongodb://localhost/#{appName}"
      redis:
        url: "localhost"
    test:
      app:
        port: port
        url: "http://localhost.#{appName}.herokuapp.com:#{port}"
      mongo:
        url: "mongodb://localhost/#{appName}-test"
      redis:
        url: "localhost"
    production:
      app:
        port: process.env.PORT
        url: url or "http://#{appName}.herokuapp.com"
      mongo:
        url: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL
      redis:
        url: process.env.REDISTOGO_URL
    common:
      fb:
        appId: '451899438203860' # TODO
        appSecret: '0a05a69a5d56da18ee2a1ffd9f53ecda' # TODO

  unless env?
    env = process.env.NODE_ENV or 'development'
  config = _.clone envs.common
  _.extend config, _.clone envs[env]
  return config
