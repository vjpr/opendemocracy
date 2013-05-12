#require 'coffee-trace'
logger = require('onelog').get()
{Live} = require 'live'
config = require('config')()
path = require 'path'
pjson = path.join process.cwd, 'package.json'

class @App extends Live.Application

  configure: ->
    @enable Live.DefaultLibraries
    #@enable Live.Mongoose
    @enable Live.Sequelize
    assets = @enable Live.Assets
    env = assets.getEnvironment()
    env.appendPath path.join process.cwd(), 'node_modules/Flat-UI'
    env.appendPath path.join process.cwd(), 'node_modules/flat-ui-pro'
    #env.registerHelper
    #  version: -> pjson.version

    # Connect logging
    # ---------------
    # Should be after asset serving unless we want to log asset requests.
    onelog = require 'onelog'
    log4js = onelog.getLibrary()
    connectLogger = require('onelog').get 'connect'
    @use log4js.connectLogger connectLogger, level: log4js.levels.INFO, format: ':method :url'
    # ---

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
      SocketsManager = require 'live/sockets/socketsManager'
      new SocketsManager server, @sessionStore,
        onConnection: (socket) ->
          SocketsConnection = require 'sockets/socketsConnection'
          new SocketsConnection socket
    @app.locals title: config.appPrettyName

    # Watch `.rose` files which compile variables into less/stylus/js files.
    #new Rosetta

    @app


class Rosetta
  rosetta = require 'rosetta'

  constructor: ->
    @logger = require('onelog').get 'Rosetta'
    paths = ['assets/app/css']
    watchr = require 'watchr'
    watchr.watch
      paths: paths
      #ignoreCustomPatterns: /(?!\.rose)$/ig
      listeners:
        change: (changeType, filePath, fileCurrStat, filePrevStat) =>
          if changeType is 'update' and
             path.extname(filePath) is '.rose'
            @logger.info 'Compiling Rosetta', path.resolve filePath
            await Rosetta.compile filePath, 'less', defer e
            @logger.error e if e
            await Rosetta.compile filePath, 'styl', defer e
            @logger.error e if e

  @compile: (file, cssFormat = 'less', done) ->
    dir = path.dirname file
    fileName = path.basename file, '.rose'
    try
      await rosetta.compile [file],
        jsFormat: 'flat'
        cssFormat: cssFormat
        jsOut: path.join dir, "generated/#{fileName}.js"
        cssOut: path.join dir, "generated/#{fileName}.#{cssFormat}"
      , defer e, outFiles
      return done e if e
      rosetta.writeFiles outFiles, (e) ->
        return done e if e
        logger.debug 'Rosetta wrote files', outFiles
        done()
    catch e
      return done e
