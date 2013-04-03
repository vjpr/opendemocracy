{Live} = require 'framework'
config = require('config')()

class @App extends Live.Application

  configure: ->
    @enable Live.DefaultLibraries
    #@enable Live.Mongoose
    @enable Live.Sequelize
    @enable Live.Assets
    @enable Live.RedisSession
    @enable Live.JadeTemplating
    #@enable Live.CoffeecupTemplating
    @enable Live.StandardPipeline
    @enable Live.PassportAuth.Middleware
    @enable Live.StandardRouter
    @enable Live.ErrorHandling
    @enable require './routes'
    @enable Live.PassportAuth.Routes
    @app.on 'server:listening', (server) =>
      SocketsManager = require 'framework/sockets/socketsManager'
      new SocketsManager server, @sessionStore,
        onConnection: (socket) ->
          SocketsConnection = require 'sockets/socketsConnection'
          new SocketsConnection socket
    @app.locals title: config.appPrettyName
    @app
