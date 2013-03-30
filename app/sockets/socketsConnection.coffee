logger = require('onelog').get 'SocketsConnection'

class SocketsConnection

  constructor: (@socket) ->
    hs = @socket.handshake
    if hs.session.passport.user?
      @common()
      @authenticated()
    else
      @common()
      @unauthenticated()

  common: =>
    # Client has sent a message.
    @socket.on 'msg', (msg, cb) =>
      @socket.emit 'msg', 'This is a test message'
    @socket.on 'hello', (msg, cb) =>
      logger.debug 'Socket.IO has received a message from client:', msg

  unauthenticated: =>
    hs = @socket.handshake
    logger.debug "Socket.IO has received a connection from an unauthenticated user"

  authenticated: =>
    hs = @socket.handshake
    logger.debug "Socket.IO has received a connection from user", hs.session.passport.user
    # Referer is the full uri of the page that the socket.io connection
    # was setup on.
    referer = hs.headers.referer
    # Assign userId to socket.
    @socket.set 'userId', hs.session.passport.user

module.exports = SocketsConnection
