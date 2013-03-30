onelog = require 'onelog'
onelog.use onelog.Log4js
logger = require('onelog').get 'Framework'
resolvePath = (_path) -> require('path').join process.cwd(), 'app', _path
path = require 'path'
validator = require 'express-validator'
flash = require 'connect-flash'
express = require 'express'

@Live =
  Application: require './application'
  Assets: require './liveAssets'
  RedisSession: ->
    express = require 'express'
    RedisStore = require('connect-redis')(express)
    redis = require('redis-url').connect @config.redis.url
    @sessionStore = new RedisStore client: redis
  Mongoose: ->
    {Model} = require resolvePath 'model'
    model = new Model mongoUri: @config.mongo.url
  PassportAuth:
    Middleware: ->
      passport = require 'passport'
      AuthController = require './passportAuth'
      @authController = new AuthController
      @authController.setupMiddleware @app
    Routes: ->
      @authController.setupRoutes @app
  JadeTemplating: ->
    cons = require 'consolidate'
    path = require 'path'
    @app.engine 'jade', cons['jade']
    @set 'views', path.join process.cwd(), 'app/views'
    @set 'view engine', 'jade'
  StandardPipeline: ->
    SITE_SECRET = 'yeah whatever'
    @use express.favicon()
    @use express.bodyParser()
    @use express.static path.join process.cwd(), 'public'
    @use express.cookieParser()
    @use express.session
      secret: @config.session.secret
      store: @sessionStore
      key: @config.session.key
    @use express.methodOverride()
    @use validator
    @use flash()
    @use (req, res, next) ->
      res.locals.info = req.flash 'info'
      res.locals.error = req.flash 'error'
      next()
  ErrorHandling: ->
    @configure 'development', =>
      @use express.errorHandler
        dumpExceptions: true
        showStack: true
      @use express.logger()
    @configure 'production', =>
      @use express.errorHandler()
  StandardRouter: ->
    @use @app.router
  DefaultLibraries: ->
    # These libraries add hooks into express and references to them are not
    # always needed.
    require 'express-resource'
    require 'colors'
  DefaultLogging: ->
    onelog.use onelog.Log4js
