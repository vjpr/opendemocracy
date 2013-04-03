module.exports = (config) ->
  appName: 'opendemocracy' # TODO
  appPrettyName: 'Open Democracy'
  port: config.port or 3031
  # TODO: Change this to the url where your site is hosted in production.
  #   See `environments/production` for usage.
  # This is provided as the address Facebook auth should callback to.
  deployUrl: 'http://www.opendemocracy.com.au'

  # Which database is used for the User model.
  services:
    user: 'sequelize'
    #user: 'mongoose'
