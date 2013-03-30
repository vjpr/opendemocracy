# Exposes config to the app.

config = null
module.exports = (env) ->
  return config if config?
  {getConfig} = require 'framework/config'
  config = getConfig env
  # TODO: Developer can modify config settings here.
  config
