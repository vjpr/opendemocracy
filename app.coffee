SITE_SECRET = 'yeah whatever'
PORT = 3030

# Vendor dependencies
connect = require('connect')
express = require 'express'
hamlc = require 'haml-coffee'
sio = require 'socket.io'
assets = require 'connect-assets'
path = require 'path'
request = require 'request'
mongooseAuth = require 'mongoose-auth'
_ = require 'underscore'
MongoStore = require('connect-mongo')(express)
Q = require 'q'

# App dependencies
routes = require("./src/routes")
Model = require('./src/model').Model
Routes = require('./src/routes').Routes

# Init db layer
# -------------
model = new Model

# Create app
app = module.exports = express.createServer()

# Connect-Assets
# --------------
assets.jsCompilers.hamlc =
  match: /\.js$/
  compileSync: (sourcePath, source) ->
    assetName = path.basename(sourcePath, '.hamlc')
    compiled = hamlc.template(source, assetName)
    compiled
app.use assets()
app.register '.hamlc', hamlc

# Session Store
# -------------
sessionStore = new MongoStore
  db: 'example'

# Express Configuration
# ---------------------
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "hamlc"
  app.use express.bodyParser()
  app.use express.static(__dirname + "/public")
  app.use express.cookieParser()
  app.use express.session
    secret: SITE_SECRET
    store: sessionStore
    key: 'express.sid'
  app.use express.methodOverride()
  app.use mongooseAuth.middleware()
  #app.use app.router

mongooseAuth.helpExpress app

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
app.listen PORT
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

# Socket.io
# ---------
io = sio.listen app
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
