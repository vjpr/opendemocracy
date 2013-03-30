# Before we do anything we initialize our config and logging.
config = require('config')()
require('config/logging')()
logger = require('onelog').get 'LiveFramework'
resolvePath = (_path) -> require('path').join process.cwd(), 'app', _path
path = require 'path'
validator = require 'express-validator'
flash = require 'connect-flash'
express = require 'express'
colors = require 'colors'

@Live =
  Application: require './application'
  Assets: require './liveAssets'
  RedisSession: ->
    express = require 'express'
    RedisStore = require('connect-redis')(express)
    redis = require('redis-url').connect @config.database.redis.url
    @sessionStore = new RedisStore client: redis
  Mongoose: ->
    MongooseAdapter = require 'mongooseDb'
    new MongooseAdapter mongoUri: @config.database.mongo.url
  Sequelize: ->
    SequelizeAdapter = require 'sequelizeDb'
    new SequelizeAdapter
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
