logger = require('onelog').get 'Mongo'
mongoose = require 'mongoose'
config = require('config')()

class MongooseAdapter

  constructor: ->

    require('./models/user')()

    mongoose.set 'debug', config.database.mongo?.debug or true

    # So testing will work. Mocha keeps our app alive somehow.
    unless mongoose.connection.readyState is 1

      logger.debug "Connecting to MongoDB at", config.database.mongo.url
      mongoose.connect config.database.mongo.url
      mongoose.connection.on 'error', (err) ->
        logger.error "MongoDB connection error: " + err
      mongoose.connection.on 'open', ->
        logger.debug "Connected to MongoDB"

module.exports = MongooseAdapter
