SITE_SECRET = 'yeah whatever'

# Vendor dependencies
connect = require('connect')
express = require 'express'
sio = require 'socket.io'
path = require 'path'
request = require 'request'
mongooseAuth = require 'mongoose-auth'
_ = require 'underscore'
MongoStore = require('connect-mongo')(express)
Q = require 'q'
colors = require 'colors'
require 'haml-coffee'
cons = require 'consolidate'
Assets = require 'live-assets'

# App dependencies
routes = require("./routes")
{Model} = require('./model')
{Routes} = require('./routes')

# Init db layer
# -------------
model = new Model

# Create app
app = express()
app.set 'port', 3030

# Live-Assets
# -----------
assets = new Assets
  paths: [
    'assets/app/js'
    'assets/app/css'
    'assets/vendor/js'
    'assets/vendor/css'
  ]
  digest: false
  expandTags: true
  assetServePath: '/assets/'
  remoteAssetsDir: '/'
  usePrecompiledAssets: false
  root: process.cwd()
  files: ['application.js', 'style.css']

# Precompile on every request.
app.use (req, res, next) ->
  env = assets.getEnvironment()
  assets.precompileForDevelopment (err) =>
    next()

assets.middleware app

app.engine 'jade', cons['jade']

# Session Store
# -------------
sessionStore = new MongoStore
  db: 'example'

# Express Configuration
# ---------------------
app.configure ->
  app.set "views", process.cwd() + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.static process.cwd() + "/public"
  app.use express.cookieParser()
  app.use express.session
    secret: SITE_SECRET
    store: sessionStore
    key: 'express.sid'
  app.use express.methodOverride()
  app.use mongooseAuth.middleware()
  #app.use app.router

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

# Routes
# ------
routes = new Routes
app.get "/", routes.index
app.get "/app", routes.app

# Start web server
# ----------------
server = require('http').createServer app
server.listen app.get('port')
console.log "Express server listening on port #{app.get('port').toString().green.bold} in #{app.get('env')} mode"

# Socket.io
# ---------
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
