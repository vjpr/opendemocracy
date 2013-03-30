logger = require('onelog').get 'LiveFramework'
config = require('config')()
express = require 'express'
#{Mixable} = require 'mixable'
_ = require 'underscore'

# So we can write `@use` instead of `app.use`, etc.
makeHelpers = (app) ->

  context = {}

  for verb in ['get', 'post', 'put', 'del']
    do (verb) ->
      context[verb] = ->
        app[verb].apply app, arguments
        #if typeof arguments[0] isnt 'object'
        #  route verb: verb, path: arguments[0], handler: arguments[1]
        #else
        #  for k, v of arguments[0]
        #    route verb: verb, path: k, handler: v

  context.use = ->
    wrappers =
      static: (p = path.join(context.root, '/public')) ->
        express.static(p)

    use = (name, arg = null) ->
      if wrappers[name]
        app.use wrappers[name](arg)
      else if typeof express[name] is 'function'
        app.use express[name](arg)

    for a in arguments
      switch typeof a
        when 'function' then app.use a
        when 'string' then use a
        when 'object' then use k, v for k, v of a

  context.configure = (p) ->
    if typeof p is 'function' then app.configure p
    else
      #app.configure k, v for k, v of p
      app.configure.apply app, arguments

  context.set = (obj) ->
    app.set.apply app, arguments
    #for k, v of obj
    #  app.set k, v

  context

class Application

  constructor: ->
    # Create @app
    @app = express()
    @app.set 'port', config.app.port
    ctx = @_getDefaultContext()
    @configure.apply ctx, [ctx]
    @

  # Create express helper function shortcuts.
  _getDefaultContext: =>
    return @ctx if @ctx?
    @ctx =
      app: @app
      config: config
      enable: @enable
    @ctx = _.extend @ctx, makeHelpers @app
    @ctx

  # Enable certain features.
  enable: (fn) =>
    ctx = @_getDefaultContext()
    fn.apply ctx, [ctx]

  start: (done = ->) =>
    app = @app
    port = app.get('port')
    @server = server = require('http').createServer app
    if app.get('env') isnt 'production'
      server.on 'error', (e) =>
        return unless config.app.tryOtherPortsIfInUse
        # If port is in use. Use next available port.
        if e.code is 'EADDRINUSE'
          newPort = port + 1
          logger.warn "Port #{port.toString()} is in use. Trying port: #{newPort}"
          #server.close()
          @createServer newPort, server, app
      server.on 'listening', =>
        @onListening server, app
        # Let others know that the server has started.
        done()
    @createServer port, server, app

  createServer: (port, server, app) ->
    server.listen port

  onListening: (server, app) ->
    port = server.address().port
    process.exit() unless port?
    logger.info "Express server listening on port #{port.toString().green.bold} in #{app.get('env')} mode"

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

module.exports = Application



