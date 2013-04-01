parseHerokuPostgresConnectionString = (herokuUrl) ->
  url     = require 'url'
  dbUrl   = url.parse herokuUrl
  authArr = dbUrl.auth.split ':'

  dbOptions = {}
  dbOptions.name          = dbUrl.path.substring(1)
  dbOptions.user          = authArr[0]
  dbOptions.pass          = authArr[1]
  dbOptions.host          = dbUrl.hostname
  dbOptions.port          = dbUrl.port
  dbOptions.dialect       = 'postgres'
  dbOptions.protocol      = 'postgres'
  dbOptions

module.exports = (config) ->

  postgresProd = if process.env.HEROKU_POSTGRESQL_MAROON_URL?
    parseHerokuPostgresConnectionString process.env.HEROKU_POSTGRESQL_MAROON_URL
  else
    {}

  mongo:
    development:
      url: "mongodb://localhost/#{config.appName}"
    test:
      url: "mongodb://localhost/#{config.appName}-test"
    production:
      url: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or "mongodb://localhost/#{config.appName}-prod"

  redis:
    development:
      url: "localhost"
    production:
      url: process.env.REDISTOGO_URL
    test:
      url: "localhost"

  sequelizePostgres:
    development:
      name: 'expressbootstrap'
      dialect: 'postgres'
      username: null
      password: null
    test:
      name: 'expressbootstrap-test'
      dialect: 'postgres'
      username: null
      password: null
    production:
      name: postgresProd.name
      username: postgresProd.user
      password: postgresProd.pass
      host: postgresProd.host
      port: postgresProd.port
      protocol: 'tcp'
      dialect: postgresProd.dialect
    #production:
    #  name: postgresProd.name
    #  username: postgresProd.username
    #  password: postgresProd.password
    #  host: process.env.HEROKU_POSTGRESQL_MAROON_URL
    #  port: postgresProd.port
    #  protocol: postgresProd.protocol
    #  dialect: postgresProd.dialect

  sequelizeMysql:
    development:
      name: 'expressbootstrap'
      username: 'root'
      password: null
    test:
      name: 'expressbootstrap-test'
      username: 'root'
      password: null
    production:
      name: 'expressbootstrap'
      username: null
      password: null
