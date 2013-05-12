sequelizeDb = require '../index'
User = sequelizeDb.model 'User'

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
    unless cb? then cb = fields
    User.find(parseInt(id)).success (data) -> cb null, data

  @findOrCreate: (profile, cb) ->
    User.findOrCreate profile, cb

  @findOne: (params, fields, cb) ->
    unless cb? then cb = fields
    User.find(params).success (data) -> cb null, data

  @create: (params, cb) ->
    User.create(params).success (data) -> cb null, data

module.exports = UserService
