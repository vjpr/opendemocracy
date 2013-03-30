mongoose = require 'mongoose'
User = mongoose.model 'User'

users = {}

class UserService

  @findByIdCached: (id, fields, cb) ->
    # TODO: Check expiry.
    return cb(null, users[id].user) if users[id]?
    User.findById id, 'id name email fb', (err, user) ->
      return cb err if err
      # Cache result in memory.
      users[user.id] = user: user
      cb null, user

  @findById: (id, fields, cb) ->
    # This will clear session if we have an invalid id stored in session.
    return cb(null, false) if typeof id is 'number'
    User.findById id, fields, cb

  @findOrCreate: (profile, cb) ->
    User.findOrCreate profile, cb

  @findOne: (params, fields, cb) ->
    User.findOne params, fields, cb

  @create: (params, cb) ->
    User.create params, cb

module.exports = UserService
