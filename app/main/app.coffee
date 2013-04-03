findPortToRunDevServer = (cb) ->
  # We must find the port our development server is going to run on
  # because it is used in some of the auth settings.
  portscanner = require 'portscanner'
  portscanner.findAPortNotInUse 3030, 3100, 'localhost', (e, port) ->
    cb e, port

# `app` is exposed because we do not want to start the app when testing
# the server.
@app = ->
  {App} = require 'config/application'
  app = new App
  # This is the Express app object for testing purposes.
  app.app

# This is invoked in `app.js` when we want to actually run the app.
@start = (env, done) ->
  unless env?
    env = process.env.NODE_ENV or 'development'
  unless env is 'production'
    findPortToRunDevServer (e, port) -> run env, port, done
  else
    run env, null, done

run = (env, port, done) ->
  require('config') env, null, {port}
  require('config/logging')()
  {App} = require 'config/application'
  app = new App
  app.start done
  return
