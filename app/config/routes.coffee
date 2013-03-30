path = require 'path'
resolvePath = (_path) -> path.join process.cwd(), 'app', _path
controller = (c) -> resolvePath path.join 'controllers', c

module.exports = ->

  @get '/', require(controller 'appController').index
  @get '/app', require(controller 'appController').app
  @get '/admin', require(controller 'adminController').index
  @get '/test', require(controller 'testController').allTests
