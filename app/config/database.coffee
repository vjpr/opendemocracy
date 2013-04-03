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
  dbOptions.protocol      = 'tcp'
  dbOptions

module.exports = (config) ->

  herokuPostgresUrl = process.env.DATABASE_URL

  postgresProd = if herokuPostgresUrl?
    parseHerokuPostgresConnectionString herokuPostgresUrl
  else
    {}

  mongo:
    development:
      url: "mongodb://localhost/#{config.appName}"
      debug: true
    test:
      url: "mongodb://localhost/#{config.appName}-test"
      debug: true
    production:
      url: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or "mongodb://localhost/#{config.appName}-prod"
      debug: false

  redis:
    development:
      url: "localhost"
    production:
      url: process.env.REDISTOGO_URL
    test:
      url: "localhost"

  sequelizePostgres:
    development:
      name: 'opendemocracy'
      dialect: 'postgres'
      username: 'postgres'
      password: null
    test:
      name: 'opendemocracy-test'
      dialect: 'postgres'
      username: 'postgres'
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
