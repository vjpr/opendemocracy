logger = require('onelog').get 'SequelizeDb'
config = require('config')()
Sequelize = require 'sequelize'

sequelize = null
models = {}

module.exports = (model) ->

  if sequelize?
    if model?
      return models[model]
    else
      throw new Error 'The sequelize model did not exist', model

  c = config.database.sequelizePostgres

  sequelize = new Sequelize c.name, c.username, c.password,
    host: c.host
    port: c.port
    dialect: c.dialect
    protocol: c.protocol or 'tcp'
    pool: { maxConnections: 5, maxIdleTime: 30 }
    logging: (msg) -> logger.debug msg

  # Add your modules here.
  models =
    User: require('./models/user')(sequelize)

  sequelize.sync().success ->
    logger.info 'Sequelize synchronization successful'
  .error (error) ->
    logger.error error
