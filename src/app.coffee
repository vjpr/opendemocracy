onelog      = require 'onelog'
onelog.use onelog.Log4js
logger      = require('onelog').get 'App'

@app = app = (opts = {}) ->

  SITE_SECRET = 'yeah whatever'

  # Vendor dependencies.
  _           = require 'underscore'
  path        = require 'path'
  Q           = require 'q'
  cons        = require 'consolidate'
  express     = require 'express'
  request     = require 'request'
  RedisStore  = require('connect-redis')(express)
  colors      = require 'colors'
  Assets      = require 'live-assets'
  Resource    = require 'express-resource'
  passport    = require 'passport'
  flash       = require 'connect-flash'
  validator   = require 'express-validator'

  # App dependencies.
  config      = require('./config')()

  # Init db layer
  logger.info "Connecting to MongoDB at", config.mongo.url
  {Model} = require './model'
  model = new Model mongoUri: config.mongo.url

  {Routes} = require './routes'

  # Create app
  app = express()
  app.set 'port', config.app.port

  # Init auth
  AuthController = require './auth'
  authController = new AuthController

  # Live-Assets
  # -----------
  assets = new Assets
    paths: [
      'assets/app/js'
      'assets/app/css'
      'assets/vendor/js'
      'assets/vendor/css'
      'assets/vendor/components'
      'test/client/app'
      'test/client/vendor'
    ]
    digest: false
    expandTags: if app.get('env') is 'production' then false else true
    assetServePath: '/assets/'
    remoteAssetsDir: '/'
    # TODO: Change last word to false.
    usePrecompiledAssets: if app.get('env') is 'production' then true else false
    root: process.cwd()
    # Add more files to this array when you need to require them from a template.
    files: [
      'application.js'
      'style.css'
      'admin.js'
      'admin.css'
      'test.js'
      'test.css'
    ]
    logger: logger

  # In development, precompile on every HTML request.
  app.configure 'development', ->
    app.use (req, res, next) ->
      isHTMLRequest = req.accepted[0].value is 'text/html'
      if isHTMLRequest
        assets.precompileForDevelopment -> next()
      else
        next()

  assets.middleware app

  app.engine 'jade', cons['jade']

  # Session Store
  # -------------
  redis = require('redis-url').connect config.redis.url
  sessionStore = new RedisStore client: redis

  # Express Configuration
  # ---------------------
  app.configure ->
    app.set 'views', process.cwd() + '/views'
    app.set 'view engine', 'jade'
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.static process.cwd() + "/public"
    app.use express.cookieParser()
    app.use express.session
      secret: SITE_SECRET
      store: sessionStore
      key: 'express.sid'
    app.use express.methodOverride()
    app.use validator
    app.use flash()
    app.use (req, res, next) ->
      res.locals.info = req.flash 'info'
      res.locals.error = req.flash 'error'
      next()
    authController.setupMiddleware app
    app.use app.router

  app.configure 'development', ->
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true
    app.use express.logger()

  app.configure 'production', ->
    app.use express.errorHandler()

  # Routes
  # ------
  routes = new Routes
  app.get "/", routes.index
  app.get "/app", routes.app
  authController.setupRoutes app

  # Admin Routes
  # ------------
  app.get "/admin", require('./routes/admin').index

  # Test Routes
  # -----------
  app.get "/test", require('./routes/test').allTests

  # Locals
  # ------

  # TODO: Change me.
  app.locals title: 'Express Bootstrap'

  app

createServer = (app) ->

  # Start web server
  # ----------------
  server = require('http').createServer app
  server.listen app.get('port')
  logger.info "Express server listening on port #{app.get('port').toString().green.bold} in #{app.get('env')} mode"

  # Socket.io
  # ---------
  sio = require 'socket.io'
  io = sio.listen server
  io.set 'log level', 1
  io.set 'authorization', (data, accept) ->
    if data.headers.cookie
      data.cookie = require('connect').utils.parseCookie data.headers.cookie
      data.sessionID = data.cookie['express.sid']
      sessionStore.get data.sessionID, (err, session) ->
        if err or not session
          accept 'Error', false
        else
          data.session = session
          accept null, true
    else
      return accept 'No cookie transmitted', false

  io.sockets.on 'connection', (socket) ->
    hs = socket.handshake
    socket.on 'hello', ->
      socket.emit 'hi'

@start = ->

  app = app()
  createServer app
