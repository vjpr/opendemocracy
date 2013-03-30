logger = require('onelog').get 'UserModel'
Sequelize = require 'sequelize'
bcrypt  = require 'bcrypt'

module.exports = (sequelize) ->

  sequelize.define 'User',
    name: Sequelize.STRING
    email: Sequelize.STRING
    password: Sequelize.STRING
    salt: Sequelize.STRING
    fb: Sequelize.TEXT
    fbId: Sequelize.STRING

  , classMethods:

    findOrCreate: (profile, cb) ->
      @find({ where: {'fbId': profile.id} }).success (user) =>
        return cb(null, user) if user
        @create({name: profile.displayName, fb: JSON.stringify(profile), fbId: profile.id}).success (user) ->
          logger.debug "Registration succeeded:", user
          cb null, user
        .error (err) ->
          if err
            logger.error "Registration failed:", err
            return cb err if err
      .error (err) ->
        return cb err if err

  , instanceMethods:

    getFb: ->
      try
        JSON.parse @fb
      catch e
        return {}

    validatePassword: (attempt) ->
      hashedAttempt = bcrypt.hashSync attempt, @salt
      @password is hashedAttempt

    getDisplayName: ->
      return @getFb().displayName if @getFb()?.displayName?
      return @name
