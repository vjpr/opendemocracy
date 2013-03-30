logger = require('onelog').get 'Model'
mongoose = require 'mongoose'
config = require('config')()
bcrypt = require 'bcrypt'

class Model

  constructor: ->

    User = require('./models/user')()

    mongoose.set 'debug', true

    # So testing will work. Mocha keeps our app alive somehow.
    unless mongoose.connection?

      logger.debug "Connecting to MongoDB at", @config.mongo.url
      mongoose.connect config.mongo.url
      mongoose.connection.on 'error', (err) ->
        logger.error "MongoDB connection error: " + err
      mongoose.connection.on 'open', ->
        logger.debug "Connected to MongoDB"

exports.Model = Model
