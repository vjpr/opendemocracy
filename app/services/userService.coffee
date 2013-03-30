config = require('config')()

userService = if config.services.user is 'sequelize'
  require 'sequelizeDb/services/userService'
else
  require 'mongooseDb/services/userService'

module.exports = userService
