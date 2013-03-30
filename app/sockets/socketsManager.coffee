logger = require('onelog').get 'SocketsManager'
_ = require 'underscore'
sio = require 'socket.io'
mongoose = require 'mongoose'
url = require 'url'
connect = require 'connect'
cookie = require 'cookie'
config = require('config')()

User = mongoose.model 'User'
SocketsConnection = require 'sockets/socketsConnection'

class SocketsManager

  constructor: (server, sessionStore) ->
    @io = io = sio.listen server
    logger.debug 'Socket.IO is listening for connections'
    io.set 'log level', 1
    # For Heroku.
    io.set 'transports', ['xhr-polling']
    io.set 'polling duration', 10
    # ---
    io.set 'authorization', (data, accept) ->
      if data.headers.cookie
        data.cookie = connect.utils.parseSignedCookies cookie.parse(data.headers.cookie), config.session.secret
        data.sessionID = data.cookie['express.sid']
        sessionStore.get data.sessionID, (err, session) ->
          if err
            accept 'Error when looking up session in store', false
          else if not session
            accept 'No session found in store for this cookie', false
          else
            data.session = session
            accept null, true
      else
        return accept 'No cookie transmitted', false
    io.sockets.on 'connection', @onConnection
    @

  onConnection: (socket) =>
    new SocketsConnection socket

module.exports = SocketsManager
