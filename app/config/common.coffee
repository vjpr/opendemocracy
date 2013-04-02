module.exports = (config) ->
  appName: 'expressbootstrap' # TODO
  appPrettyName: 'Express Bootstrap'
  port: 3030
  # TODO: Change this to the url where your site is hosted in production.
  #   See `environments/production` for usage.
  # This is provided as the address Facebook auth should callback to.
  deployUrl: null

  # Which database is used for the User model.
  services:
    #user: 'sequelize'
    user: 'mongoose'
