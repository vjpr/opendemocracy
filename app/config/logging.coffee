colors = require 'colors'
onelog = require 'onelog'
_ = require 'underscore'
config = require('config')()
log4js = require 'log4js'
{DefaultLogging} = require 'framework/logging'

module.exports = (env) ->
  env = config.env unless env?
  #log4js.replaceConsole()
  log4js.setGlobalLogLevel 'INFO'

  switch env

    when 'production', 'staging'
      log4js.setGlobalLogLevel 'TRACE'
      log4js.configure
        appenders: DefaultLogging.productionAppender
        levels: _.extend DefaultLogging.prodLevels, {} # TODO: Add new levels here.

    when 'development'
      log4js.setGlobalLogLevel 'TRACE'
      log4js.configure
        appenders: DefaultLogging.developmentAppender
        levels: _.extend DefaultLogging.devLevels, {} # TODO: Add new levels here.

    when 'test'
      log4js.setGlobalLogLevel 'WARN'
      log4js.configure
        appenders: DefaultLogging.developmentAppender
        levels: {} # TODO: Add new levels here.

  onelog.use onelog.Log4js
