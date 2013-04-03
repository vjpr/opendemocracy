# Exposes config to the app.

config = null
# force - Forces regeneration of config hash even if already cached.
#   Used when the port our app is running on changes.
# _config - Pass in configuration hash to override any settings that are
#   overrideable.
module.exports = (env, force = false, _config) ->
  unless force
    return config if config?
  {getConfig} = require 'framework/config'
  config = getConfig env, _config
  # TODO: Developer can modify config settings here.
  config
