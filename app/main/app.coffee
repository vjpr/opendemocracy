# `app` is exposed because we do not want to start the app when testing
# the server.
@app = ->
  {App} = require 'config/application'
  app = new App
  # This is the Express app object for testing purposes.
  app.app

# This is invoked in `app.js` when we want to actually run the app.
@start = (done) ->
  {App} = require 'config/application'
  app = new App
  app.start done
  app
