mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->

  UserSchema = new Schema
    name: String
    email: String
    password: String
    salt: String
    fb: Schema.Types.Mixed

  UserSchema.methods.validatePassword = (attempt) ->
    hashedAttempt = bcrypt.hashSync attempt, @salt
    @password is hashedAttempt

  UserSchema.statics.findOrCreate = (profile, cb) ->
    @findOne {'fb.id': profile.id}, (err, user) =>
      return cb err if err
      return cb(null, user) if user
      @create {name: profile.displayName, fb: profile}, (err, user) =>
        if err
          logger.error "Registration failed:", err
          return cb err if err
        logger.debug "Registration succeeded:", user
        cb null, user

  UserSchema.methods.getDisplayName = ->
    return @fb.displayName if @fb?.displayName?
    return @name

  @User = mongoose.model 'User', UserSchema

  @User
