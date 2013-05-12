path = require 'path'
resolvePath = (_path) -> path.join process.cwd(), 'app', _path
controller = (c) -> resolvePath path.join 'controllers', c

# Only allow authenticated users to access certain routes.
ensureAuthenticated = (req, res, next) ->
  unless req.user then return res.redirect('login') else next()

module.exports = ->

  @get '/', require(controller 'appController').index
  @get '/app', ensureAuthenticated, require(controller 'appController').app
  @get '/admin', require(controller 'adminController').index
  @get '/test', require(controller 'testController').allTests
  @app.resource 'props', require(controller 'prop')
