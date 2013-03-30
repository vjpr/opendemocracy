_ = require 'underscore'

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

# Performs a deep copy of an object (assumes each object is a dictionary).
merge = (srcs...) ->
  output = {}
  for src in srcs
    for key, value of src
      if _.isObject(value)
        output[key] ?= {}
        output[key] = merge(output[key], value)
      else
        output[key] = value
  return output

@getConfig = (env) ->

  unless env?
    env = process.env.NODE_ENV or 'development'
  validEnvironments = ['development', 'test', 'production']
  unless _.contains validEnvironments, env
    throw new Error "#{env} is not a valid environment"

  config = env: env
  config = merge config, require('config/common')
  config = merge config, require("config/environments/#{env}")(config)
  , {database: extractSettingsForEnvironment(env, require('config/database')(config))}
  , {session: require('config/session')}
  , {credentials: require('config/credentials')}

  return config
