#= require underscore/underscore
#= require backbone/backbone
#= require jade-runtime
#= require_tree ../templates

# Workaround jade-runtime's use of `require`.
require = -> readFileSync: -> ''

$(document).ready ->
  # Client-side template functions are accessible as follows:
  # `JST['templates/home']()`

  # Enable Socket.IO.
  window.socket = io.connect()
  socket.on 'msg', (msg) ->
    console.log 'Received socket.io message', msg
  # Send a test message to server on connection.
  socket.on 'connect', ->
    socket.emit 'hello', 'Hello, World!'
