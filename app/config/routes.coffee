path = require 'path'
resolvePath = (_path) -> path.join process.cwd(), 'app', _path
controller = (c) -> resolvePath path.join 'controllers', c

module.exports = ->

  @get '/', require(controller 'app').index
  @get '/app', require(controller 'app').app
  @get '/admin', require(controller 'admin').index
  @get '/test', require(controller 'test').allTests
