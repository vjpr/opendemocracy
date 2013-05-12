# Singleton

logger = require('onelog').get 'SequelizeDb'
config = require('config')()
Sequelize = require 'sequelize'
_ = require 'underscore'

sequelize = null
models = {}

module.exports = class SequlizeDb

  @model: (model) ->

    if sequelize?
      if models[model]?
        return models[model]
      else
        throw new Error 'The sequelize model did not exist', model

  @models: ->
    models if sequelize?

  @get: -> sequelize

  @init: (done = ->) ->

    c = config.database.sequelizePostgres

    sequelize = new Sequelize c.name, c.username, c.password,
      host: c.host or 'localhost'
      port: c.port or '5432'
      dialect: c.dialect or 'postgres'
      protocol: c.protocol or 'tcp'
      pool: { maxConnections: 5, maxIdleTime: 30 }
      logging: (msg) -> logger.debug msg

    # Add your modules here.
    models =
      User: require('./models/user')(sequelize)

    _.extend models, require('./models/models')(sequelize)

    # DEBUG
    #await exports.seed defer e; return done e if e

    done null, sequelize

  @sync: (done) ->
    await sequelize.sync().done defer e
    if e
      return done e
      logger.error error
    logger.info 'Sequelize synchronization successful'

  # Seed db from scratch
  @seed: (done) ->
    await sequelize.drop().done defer e
    return done e if e
    await sequelize.sync().done defer e
    return done e if e
    seeds = require './seeds'
    seeds.run models, done
