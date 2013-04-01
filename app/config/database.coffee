module.exports = (config) ->

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

  sequelize:
    development:
      name: 'expressbootstrap'
      username: null
      password: null
    test:
      name: 'expressbootstrap-test'
      username: null
      password: null
    production:
      name: 'expressbootstrap'
      username: null
      password: null
      host: process.env.HEROKU_POSTGRESQL_MAROON_URL

  sequelize_mysql:
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
