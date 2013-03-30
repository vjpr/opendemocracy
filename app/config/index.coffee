_ = require 'underscore'

config = null

# If settings look like this:
#   mongo:
#     development: ...
#     production: ...
#   redis: ...
# We extract the settings for the given environment.
extractSettingsForEnvironment = (env, settings) ->
  settingsForEnv = {}
  _.each settings, (v, k) -> settingsForEnv[k] = v[env]
  settingsForEnv

# Exposes config to the app.
module.exports = (env) ->
  return config if config?
  unless env?
    env = process.env.NODE_ENV or 'development'
  validEnvironments = ['development', 'test', 'production']
  unless _.contains validEnvironments, env
    throw new Error "#{env} is not a valid environment"

  config = {}
  _.extend config, require('./common')
  _.extend config, require("./environments/#{env}") config
  _.extend config, extractSettingsForEnvironment env, require('./database')(config)
  _.extend config, {session: require('./session')}
  _.extend config, require('./credentials')

  return config
